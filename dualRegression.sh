for sub in {9001..9100}
 do
 	#Resample the GM mask
	3dresample -master FSLMNI152_T1_1mm_brain.nii.gz -input sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_ANTS_BrainExtractionGM.nii.gz -prefix sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_GM_res2func.nii.gz

 	echo "=================$sub network mask to func"


	#Send resampled gm mask to func space
	antsApplyTransforms -d 3 -n NearestNeighbor \
		-r sub-"$sub"/sub-"$sub"_first_bet.nii.gz \
		-i sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_GM_res2func.nii.gz \
		-t [sub-"$sub"/sub-"$sub"_func2T1/sub-"$sub"_EPI2anat_mat0GenericAffine.mat, 1] \
		-o sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_GM2infunc.nii.gz

	for network in ContA ContB ContC DefaultA DefaultB DefaultC DorsAttnA DorsAttnB LimbicA LimbicB SalVenAttnA SalVenAttnB SomMotA SomMotB TempPar VisCent VisPeri
	do
		echo "=======================$sub $network"
		#Send resampled network mask to func space
		antsApplyTransforms -d 3 -n NearestNeighbor \
			-r sub-"$sub"/sub-"$sub"_first_bet.nii.gz \
			-i FIND/"$network"_res.nii.gz \
			-t [sub-"$sub"/sub-"$sub"_func2T1/sub-"$sub"_EPI2anat_mat0GenericAffine.mat, 1] \
			-t [sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_0GenericAffine.mat, 1] \
			-t sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_1InverseWarp.nii.gz \
			-o sub-"$sub"/masks/sub-"$network"_infunc.nii.gz
	 	

	 	#Combine GM and network mask
	 	3dcalc -a sub-"$sub"/masks/sub-"$network"_infunc.nii.gz -b sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_GM2infunc.nii.gz -expr '(a*b)' -prefix sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$network"_GM_infunc.nii.gz

	 	#Take the mean signal
		3dmaskave -quiet -mask sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$network"_GM_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_errts_sm.nii.gz > sub-"$sub"/Deconvolve/sub-"$sub"_"$network"_infunc_noeyes.txt
		3dmaskave -quiet -mask sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$network"_GM_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_witheyes_errts_wav_sm.nii.gz > sub-"$sub"/Deconvolve/sub-"$sub"_"$network"_infunc_wav.txt

	done

	#regress the functional files with the mean signal extracted in the previous step 
	echo "=================$sub Deconvolve witheyes"
	3dDeconvolve -float -jobs 8 -input sub-"$sub"/Deconvolve/sub-"$sub"_witheyes_errts_wav_sm.nii.gz -polort -1 -num_stimts 17\
	-stim_file 1 sub-"$sub"/masks/sub-"$sub"_yeo17_ContA_witheyes.txt -stim_label 1 ContA \
	-stim_file 2 sub-"$sub"/masks/sub-"$sub"_yeo17_ContB_witheyes.txt -stim_label 2 ContB \
	-stim_file 3 sub-"$sub"/masks/sub-"$sub"_yeo17_ContC_witheyes.txt -stim_label 3 ContC \
	-stim_file 4 sub-"$sub"/masks/sub-"$sub"_yeo17_DefaultA_witheyes.txt -stim_label 4 DefaultA \
	-stim_file 5 sub-"$sub"/masks/sub-"$sub"_yeo17_DefaultB_witheyes.txt -stim_label 5 DefaultB \
	-stim_file 6 sub-"$sub"/masks/sub-"$sub"_yeo17_DefaultC_witheyes.txt -stim_label 6 DefaultC \
	-stim_file 7 sub-"$sub"/masks/sub-"$sub"_yeo17_DorsAttnA_witheyes.txt -stim_label 7 DorsAttnA \
	-stim_file 8 sub-"$sub"/masks/sub-"$sub"_yeo17_DorsAttnB_witheyes.txt -stim_label 8 DorsAttnB \
	-stim_file 9 sub-"$sub"/masks/sub-"$sub"_yeo17_LimbicA_witheyes.txt -stim_label 9 LimbicA \
	-stim_file 10 sub-"$sub"/masks/sub-"$sub"_yeo17_LimbicB_witheyes.txt -stim_label 10 LimbicB \
	-stim_file 11 sub-"$sub"/masks/sub-"$sub"_yeo17_SalVenAttnA_witheyes.txt -stim_label 11 SalVenAttnA \
	-stim_file 12 sub-"$sub"/masks/sub-"$sub"_yeo17_SalVenAttnB_witheyes.txt -stim_label 12 SalVenAttnB \
	-stim_file 13 sub-"$sub"/masks/sub-"$sub"_yeo17_SomMotA_witheyes.txt -stim_label 13 SomMotA \
	-stim_file 14 sub-"$sub"/masks/sub-"$sub"_yeo17_SomMotB_witheyes.txt -stim_label 14 SomMotB \
	-stim_file 15 sub-"$sub"/masks/sub-"$sub"_yeo17_TempPar_witheyes.txt -stim_label 15 TempPar \
	-stim_file 16 sub-"$sub"/masks/sub-"$sub"_yeo17_VisCent_witheyes.txt -stim_label 16 VisCent \
	-stim_file 17 sub-"$sub"/masks/sub-"$sub"_yeo17_VisPeri_witheyes.txt -stim_label 17 VisPeri \
	-noFDR -tout -bout -nofullf_atall -nodmbase -nfirst 0 -overwrite \
	-bucket sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_witheyes.nii.gz

	echo "=================$sub Deconvolve no eyes"
	3dDeconvolve  -float -jobs 8 -input sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_errts_sm.nii.gz -polort -1 -num_stimts 17\
	-stim_file 1 sub-"$sub"/masks/sub-"$sub"_yeo17_ContA_noeyes_txt -stim_label 1 ContA \
	-stim_file 2 sub-"$sub"/masks/sub-"$sub"_yeo17_ContB_noeyes_txt -stim_label 2 ContB \
	-stim_file 3 sub-"$sub"/masks/sub-"$sub"_yeo17_ContC_noeyes_txt -stim_label 3 ContC \
	-stim_file 4 sub-"$sub"/masks/sub-"$sub"_yeo17_DefaultA_noeyes_txt -stim_label 4 DefaultA \
	-stim_file 5 sub-"$sub"/masks/sub-"$sub"_yeo17_DefaultB_noeyes_txt -stim_label 5 DefaultB \
	-stim_file 6 sub-"$sub"/masks/sub-"$sub"_yeo17_DefaultC_noeyes_txt -stim_label 6 DefaultC \
	-stim_file 7 sub-"$sub"/masks/sub-"$sub"_yeo17_DorsAttnA_noeyes_txt -stim_label 7 DorsAttnA \
	-stim_file 8 sub-"$sub"/masks/sub-"$sub"_yeo17_DorsAttnB_noeyes_txt -stim_label 8 DorsAttnB \
	-stim_file 9 sub-"$sub"/masks/sub-"$sub"_yeo17_LimbicA_noeyes_txt -stim_label 9 LimbicA \
	-stim_file 10 sub-"$sub"/masks/sub-"$sub"_yeo17_LimbicB_noeyes_txt -stim_label 10 LimbicB \
	-stim_file 11 sub-"$sub"/masks/sub-"$sub"_yeo17_SalVenAttnA_noeyes_txt -stim_label 11 SalVenAttnA \
	-stim_file 12 sub-"$sub"/masks/sub-"$sub"_yeo17_SalVenAttnB_noeyes_txt -stim_label 12 SalVenAttnB \
	-stim_file 13 sub-"$sub"/masks/sub-"$sub"_yeo17_SomMotA_noeyes_txt -stim_label 13 SomMotA \
	-stim_file 14 sub-"$sub"/masks/sub-"$sub"_yeo17_SomMotB_noeyes_txt -stim_label 14 SomMotB \
	-stim_file 15 sub-"$sub"/masks/sub-"$sub"_yeo17_TempPar_noeyes_txt -stim_label 15 TempPar \
	-stim_file 16 sub-"$sub"/masks/sub-"$sub"_yeo17_VisCent_noeyes_txt -stim_label 16 VisCent \
	-stim_file 17 sub-"$sub"/masks/sub-"$sub"_yeo17_VisPeri_noeyes_txt -stim_label 17 VisPeri \
	-noFDR -tout -bout -nofullf_atall -nodmbase -nfirst 0 -overwrite \
	-bucket sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_noeyes.nii.gz


	echo "=======================extract the coefs $sub"
	for type in noeyes witheyes
		do
		#seperate the coefficients
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_ContA_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[0]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_ContB_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[2]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_ContC_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[4]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_DefaultA_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[6]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_DefaultB_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[8]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_DefaultC_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[10]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_DorsAttnA_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[12]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_DorsAttnB_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[14]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_LimbicA_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[16]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_LimbicB_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[18]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_SalVenAttnA_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[20]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_SalVenAttnB_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[22]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_SomMotA_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[24]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_SomMotB_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[26]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_TempPar_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[28]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_VisCent_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[30]
		3dbucket -overwrite -prefix sub-"$sub"/Deconvolve/sub-"$sub"_VisPeri_"$type"_Coef_infunc.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_yeo_infunc_"$type".nii.gz[32]
	done

	for network in ContA ContB ContC DefaultA DefaultB DefaultC DorsAttnA DorsAttnB LimbicA LimbicB SalVenAttnA SalVenAttnB SomMotA SomMotB TempPar VisCent VisPeri
	do
		for type in noeyes witheyes
		do
			 #Send the coefs to MNI
			antsApplyTransforms -d 3 -v -n LanczosWindowedSinc \
			-r FSLMNI_res.nii.gz \
			-i sub-"$sub"/Deconvolve/sub-"$sub"_"$network"_"$type"_Coef_infunc.nii.gz \
			-t sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toFSLMNI_1Warp.nii.gz \
			-t [sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toFSLMNI_0GenericAffine.mat] \
			-t [sub-"$sub"/sub-"$sub"_func2T1/sub-"$sub"_EPI2anat_mat0GenericAffine.mat] \
			-o sub-"$sub"/Deconvolve/sub-"$sub"_"$network"_"$type"_Coef_FSLMNI.nii.gz 
		done
	done
done

for network in ContA ContB ContC DefaultA DefaultB DefaultC DorsAttnA DorsAttnB LimbicA LimbicB SalVenAttnA SalVenAttnB SomMotA SomMotB TempPar VisCent VisPeri
do
	#3merge the coefs into a file 
	echo "================= create bucket file  $network"
	find . -type f | grep "$network" | grep witheyes_Coef_FSLMNI | sort > Yeo/"$network"_yeo_list.txt
	find . -type f | grep "$network" | grep noeyes_Coef_FSLMNI | sort >> Yeo/"$network"_yeo_list.txt
	3dbucket -prefix Yeo/"$network"_yeo_all.nii.gz $(cat Yeo/"$network"_yeo_list.txt) -overwrite
	
	#paired t-test with tfce
	fsl5.0-randomise -i Yeo/"$network"_yeo_all.nii.gz -o Yeo/perm/"$network"_perm -d dryeo.mat -t dryeo.con -e dryeo.grp -m FSLMNI_res.nii.gz -n 10000 -T -D -x
	fsl5.0-randomise -i Yeo/"$network"_yeo_all.nii.gz -o Yeo/perm/"$network"_perm -d dryeo.mat -t dryeo.con -e dryeo.grp -m FSLMNI_res.nii.gz -n 10000 -T -D -x
done