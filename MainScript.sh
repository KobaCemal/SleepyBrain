

# ########################################################Anatomical
for sub in $(cat list.txt) # All the subject IDs are in this txt file. Folders of the subujects that have a non-sleep-deprived resting-stat run were moved to a folder named "healthyRuns". $(cat blinklist.txt) 
do

 echo -e "===========================================\n$sub $sub $sub\n=================================================="
# Resample the anatomical images to 1x1x1 mm resolution. Original dimensions are 1x0.469x0.469
3dresample -prefix sub-"$sub"/sub-"$sub"_T1_res.nii.gz -dxyz 1 1 1 -input sub-"$sub"/sub-"$sub"_T1.nii.gz

## Segmentation of Gray matter, white matter, CSF, brain extraction and bias field correction
antsBrainExtraction.sh -d 3 -a sub-"$sub"/sub-"$sub"_T1_res.nii.gz -e MICCAI2012-Multi-Atlas-Challenge-Data/T_template0.nii.gz -m MICCAI2012-Multi-Atlas-Challenge-Data/T_template0_BrainCerebellumProbabilityMask.nii.gz  -o sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_ANTS_

## Masks are eroded to be conservative. Those eroded masks will be used to get mean signal of their respective tissues. WM and CSF signals will be used as regressors of no interest in the model.
3dmask_tool -input sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_ANTS_BrainExtractionCSF.nii.gz -dilate_input -1 -prefix sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_CSF_eroded.nii.gz
3dmask_tool -input sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_ANTS_BrainExtractionGM.nii.gz -dilate_input -1 -prefix sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_GM_eroded.nii.gz
3dmask_tool -input sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_ANTS_BrainExtractionWM.nii.gz -dilate_input -1 -prefix sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_WM_eroded.nii.gz

## Registration to MNI. We need MNI alignment for two things: First to send the eye masks to subject spacee (by using inverse transform) and second to send the residuals to MNI space to do group level comparison. Initially we used assymetric template but Schafer's parcellation required the symmetric template. 
mkdir sub-"$sub"/sub-"$sub"_T1toMNI
antsRegistrationSyN.sh -d 3 -t s -n 10 -f mni_icbm152_nlin_asym_09c/mni_1mm_assym_brain.nii.gz -m sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_ANTS_BrainExtractionBrain.nii.gz -o sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_
antsRegistrationSyN.sh -d 3 -t s -n 10 -f FSLMNI152_T1_1mm_brain.nii.gz -m sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_ANTS_BrainExtractionBrain.nii.gz -o sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toFSLMNI_




########################################################Functional
## Resting state session takes 8 minutes (192 TR). Some functional files are longer than 192. But publisher wrote that after 8 minutes, the fixation point disseppears, which means the task is over. Therefore, I removed the volumes after 192 time points. If the file had 192 volumes originally, I still saved them as "trimmed" for the sake of consistency.
## Removing first 10 volumes
3dTcat -prefix sub-"$sub"/sub-"$sub"_182.nii.gz sub-"$sub"/sub-"$sub"_trimmed.nii.gz[10..191]

## ST Correction (based on the timing sequence supplied by the publisher)
3dTshift -prefix sub-"$sub"/sub-"$sub"_st.nii.gz -tpattern @st.txt sub-"$sub"/sub-"$sub"_182.nii.gz

## Brain extraction and mean image for functional image
3dbucket -prefix sub-"$sub"/sub-"$sub"_first.nii.gz sub-"$sub"/sub-"$sub"_st.nii.gz[0]
3dAutomask -prefix sub-"$sub"/sub-"$sub"_func-mask.nii.gz sub-"$sub"/sub-"$sub"_first.nii.gz
3dmask_tool -prefix sub-"$sub"/sub-"$sub"_func-mask_dil.nii.gz -input sub-"$sub"/sub-"$sub"_func-mask.nii.gz -dilate_input 1
3dcalc -a sub-"$sub"/sub-"$sub"_first.nii.gz -b sub-"$sub"/sub-"$sub"_func-mask.nii.gz -expr '(a*b)' -prefix sub-"$sub"/sub-"$sub"_first_bet.nii.gz
3dcalc -a sub-"$sub"/sub-"$sub"_func-mask.nii.gz -b sub-"$sub"/sub-"$sub"_st.nii.gz -expr '(a*b)' -prefix sub-"$sub"/sub-"$sub"_st_bet.nii.gz

## Motion Correction. Base image is the first image of the run.
mkdir sub-"$sub"/sub-"$sub"_motcor
3dvolreg -prefix sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc.nii.gz \
 	-base sub-"$sub"/sub-"$sub"_first.nii.gz -1Dfile sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_mot-param.1D \
	-maxdisp1D sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_maxdisp.1D \
	sub-"$sub"/sub-"$sub"_st.nii.gz
1dplot -volreg -sepscl -png sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_MotCor sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_mot-param.1D 
1dplot -png sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_MotCor_Rel sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_maxdisp_delt.1D 
1dplot -png sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_MotCor_Abs sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_maxdisp.1D 

## Band-pass filtering
3dBandpass -prefix sub-"$sub"/sub-"$sub"_filtered.nii.gz -band 0.01 0.1 -input sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc.nii.gz

## Registration to T1 (T1's resolution is resampled to match with functional run's resolution)
3dresample -prefix sub-"$sub"/sub-"$sub"_T1_res2func_bet.nii.gz -master sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc.nii.gz -input sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_ANTS_BrainExtractionBrain.nii.gz 
3dresample -prefix sub-"$sub"/sub-"$sub"_T1_res2func_skull.nii.gz -master sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc.nii.gz -input sub-"$sub"/sub-"$sub"_T1.nii.gz

mkdir sub-"$sub"/sub-"$sub"_func2T1
antsRegistration -d 3 -t Affine[0.1] \
-m MI[sub-"$sub"/sub-"$sub"_T1_res2func_skull.nii.gz,sub-"$sub"/sub-"$sub"_first.nii.gz] \
-c 0 -f 3 -l -u 1 -s 2 \
-n Linear \
-o [sub-"$sub"/sub-"$sub"_func2T1/sub-"$sub"_EPI2anat_mat,sub-"$sub"/sub-"$sub"_func2T1/sub-"$sub"_EPI2anat.nii.gz]
	
## Eye masks to functional space in one transformation. Eye mask was drawn in mricron software. Eyeholes of MNI template were chosen as ROI.
mkdir sub-"$sub"/masks
antsApplyTransforms -d 3 -n NearestNeighbor \
-r sub-"$sub"/sub-"$sub"_first.nii.gz \
-i 	MNI_eyes_res.nii.gz \
-t [sub-"$sub"/sub-"$sub"_func2T1/sub-"$sub"_EPI2anat_mat0GenericAffine.mat, 1] \
-t [sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_0GenericAffine.mat, 1] \
-t sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_1InverseWarp.nii.gz \
-o sub-"$sub"/masks/sub-"$sub"_eyes2func.nii.gz

## Resample the tissue masks to lower resolution
3dresample -input sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$tissue"_eroded.nii.gz -prefix sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$tissue"_res.nii.gz

## CSF, GM, WM masks to functional space
for tissue in GM WM CSF
do 	
#3dresample -input sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$tissue"_eroded.nii.gz -prefix sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$tissue"_res.nii.gz
antsApplyTransforms -d 3 -n NearestNeighbor \
-r sub-"$sub"/sub-"$sub"_first.nii.gz \
-i sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$tissue"_res.nii.gz \
-t [sub-"$sub"/sub-"$sub"_func2T1/sub-"$sub"_EPI2anat_mat0GenericAffine.mat, 1] \
-o sub-"$sub"/masks/sub-"$sub"_"$tissue"2func.nii.gz
done

## T1 to Functional space
antsApplyTransforms -d 3 -n LanczosWindowedSinc \
-r sub-"$sub"/sub-"$sub"_first.nii.gz \
-i sub-"$sub"/sub-"$sub"_T1_res.nii.gz \
-t [sub-"$sub"/sub-"$sub"_func2T1/sub-"$sub"_EPI2anat_mat0GenericAffine.mat, 1] \
-o sub-"$sub"/masks/sub-"$sub"_T12func.nii.gz

## Quality images consist of eye masks in subject space. They are created to see how well the masks are aligned. 
mkdir quality
fsl5.0-overlay 1 1 sub-"$sub"/masks/sub-"$sub"_T12func.nii.gz -a sub-"$sub"/masks/sub-"$sub"_eyes2func.nii.gz 1 1000 sub-"$sub"/masks/sub-"$sub"_eyes2func_quality.nii.gz
fsl5.0-slicer sub-"$sub"/masks/sub-"$sub"_eyes2func_quality.nii.gz  -A 2000  quality/sub-"$sub"_eyes2func_quality.png


## Extract mean eye,CSF,GM,WM signals
for str in GM WM CSF
do
3dmaskave -quiet -mask sub-"$sub"/masks/sub-"$sub"_"$str"2func.nii.gz sub-"$sub"/sub-"$sub"_filtered.nii.gz > sub-"$sub"/masks/sub-"$sub"_"$str".txt
done


## Create a file that contains regressor of no interest
cat sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_maxdisp_delt.1D | tail -n +3 > sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_maxdisp_delt_tr.1D
paste -d " " sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_mot-param.1D sub-"$sub"/masks/sub-"$sub"_WM.txt sub-"$sub"/masks/sub-"$sub"_CSF.txt sub-"$sub"/sub-"$sub"_motcor/sub-"$sub"_mc_maxdisp_delt_tr.1D > sub-"$sub"/sub-"$sub"_ortvec.txt



## Deconvolve using those regressor: motion parameters (6), FD, WM, CSF. Then, convolved (and not convolved) eye series are regressed out from residuals.
mkdir sub-"$sub"/Deconvolve
3dDeconvolve -jobs 6 -float -input sub-"$sub"/sub-"$sub"_filtered.nii.gz -polort -1 -num_stimts 0  \
-ortvec sub-"$sub"/sub-"$sub"_ortvec.txt \
-noFDR -tout -bout -nofullf_atall -nodmbase -nfirst 0 \
-errts sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_errts.nii.gz \
-bucket sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_bucket.nii.gz

## Smoothing the residuals
3dBlurToFWHM -prefix sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_errts_sm.nii.gz -FWHM 6 -input sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_errts.nii.gz


3dmaskave -quiet -mask sub-"$sub"/masks/sub-"$sub"_eyes2func.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_errts_sm.nii.gz > sub-"$sub"/masks/sub-"$sub"_eyes_nowav_sm.txt
waver -numout 182 -dt 2.5 -input sub-"$sub"/masks/sub-"$sub"_eyes_nowav_sm.txt -WAV >  sub-"$sub"/masks/sub-"$sub"_eyes_wav_sm.txt

## Get the coefficients of convolved and raw EM for whole brain
3dDeconvolve -jobs 6 -float -input sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_errts_sm.nii.gz -polort -1 -num_stimts 1  \
-stim_file 1 sub-"$sub"/masks/sub-"$sub"_eyes_wav_sm.txt -stim_base 1 -stim_label 1 eyes \
-noFDR -tout -bout -nofullf_atall -nodmbase -nfirst 0 \
-errts sub-"$sub"/Deconvolve/sub-"$sub"_witheyes_errts_wav_sm.nii.gz \
-bucket sub-"$sub"/Deconvolve/sub-"$sub"_witheyes_bucket_wav_sm.nii.gz

3dDeconvolve -jobs 6 -float -input sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_errts_sm.nii.gz -polort -1 -num_stimts 1  \
-stim_file 1 sub-"$sub"/masks/sub-"$sub"_eyes_nowav_sm.txt -stim_base 1 -stim_label 1 eyes \
-noFDR -tout -bout -nofullf_atall -nodmbase -nfirst 0 \
-errts sub-"$sub"/Deconvolve/sub-"$sub"_witheyes_errts_nowav_sm.nii.gz \
-bucket sub-"$sub"/Deconvolve/sub-"$sub"_witheyes_bucket_nowav_sm.nii.gz

# #### Save the coefficients of eye regressors and motion regressorrs, then send them to MNI
3dbucket sub-"$sub"/Deconvolve/sub-"$sub"_sub-"$sub"_witheyes_bucket_nowav_sm.nii.gz[0] -prefix sub-"$sub"/Deconvolve/sub-"$sub"_eyesCoef_nowav_sm.nii.gz
3dbucket sub-"$sub"/Deconvolve/sub-"$sub"_sub-"$sub"_witheyes_bucket_wav_sm.nii.gz[0] -prefix sub-"$sub"/Deconvolve/sub-"$sub"_eyesCoef_wav_sm.nii.gz


antsApplyTransforms -d 3 -n LanczosWindowedSinc \
-r mni_icbm152_nlin_asym_09c/mni_func2res2.nii.gz \
-i sub-"$sub"/Deconvolve/sub-"$sub"_eyesCoef_nowav_sm.nii.gz \
-t sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_1Warp.nii.gz \
-t [sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_0GenericAffine.mat] \
-t [sub-"$sub"/sub-"$sub"_func2T1/sub-"$sub"_EPI2anat_mat0GenericAffine.mat] \
-o sub-"$sub"/Deconvolve/sub-"$sub"_eyesCoefinMNI_nowav_sm.nii.gz

antsApplyTransforms -d 3 -n LanczosWindowedSinc \
-r mni_icbm152_nlin_asym_09c/mni_func2res2.nii.gz \
-i sub-"$sub"/Deconvolve/sub-"$sub"_eyesCoef_wav_sm.nii.gz \
-t sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_1Warp.nii.gz \
-t [sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_0GenericAffine.mat] \
-t [sub-"$sub"/sub-"$sub"_func2T1/sub-"$sub"_EPI2anat_mat0GenericAffine.mat] \
-o sub-"$sub"/Deconvolve/sub-"$sub"_eyesCoefinMNI_wav_sm.nii.gz

done    


## Follows permutation procedure

