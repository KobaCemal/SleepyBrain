for sub in  {9001..9100}
do
	echo "=================$sub GM to MNI"



	#Send GM mask to MNI and resample
	antsApplyTransforms -v -d 3 -n NearestNeighbor \
	-r mni_icbm152_nlin_asym_09c/mni_func2res2.nii.gz \
	-i sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_ANTS_BrainExtractionGM.nii.gz\
	-t sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_1Warp.nii.gz \
	-t [sub-"$sub"/sub-"$sub"_T1toMNI/sub-"$sub"_T1toMNI_0GenericAffine.mat] \
	-o sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_GM_MNI.nii.gz
	3dresample -master mni_icbm152_nlin_asym_09c/mni_func2res2.nii.gz -input sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_GM_MNI.nii.gz -prefix sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_GM_MNI_res.nii.gz

	for network in Auditory Basal_Ganglia dDMN vDMN LECN RECN Language Precuneus anterior_Salience post_Salience Sensorimotor high_Visual prim_Visual Visuospatial
	do
		echo "================= $sub Extracting mean signal from $network mask"
		#Combine the network mask and gm mask
		3dcalc -a FIND/"$network"_res.nii.gz -b sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_GM_MNI_res.nii.gz -expr '(a*b)' -prefix sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$network"_GM.nii.gz
	
		#extract the mean signal within the mask of the network
		3dmaskave -quiet -mask sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$network"_GM.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_errts_sm_MNI.nii.gz > sub-"$sub"/Deconvolve/sub-"$sub"_"$network"_noeyes.txt
		3dmaskave -quiet -mask sub-"$sub"/sub-"$sub"_ANTS/sub-"$sub"_"$network"_GM.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_witheyes_errts_wav_sm_MNI.nii.gz > sub-"$sub"/Deconvolve/sub-"$sub"_"$network"_wav.txt
	done

	#regress the functional files with the mean signal extracted in the previous step 
	echo "=================$sub Deconvolve noeyes"
	3dDeconvolve -jobs 6 -float -input sub-"$sub"/Deconvolve/sub-"$sub"_noeyes_errts_sm_MNI.nii.gz -polort -1 -num_stimts 14\
	-stim_file 1 sub-"$sub"/Deconvolve/sub-"$sub"_anterior_Salience_noeyes.txt -stim_label 1 anterior_Salience \
	-stim_file 2 sub-"$sub"/Deconvolve/sub-"$sub"_Auditory_noeyes.txt -stim_label 2 Auditory \
	-stim_file 3 sub-"$sub"/Deconvolve/sub-"$sub"_Basal_Ganglia_noeyes.txt -stim_label 3 Basal_Ganglia \
	-stim_file 4 sub-"$sub"/Deconvolve/sub-"$sub"_dDMN_noeyes.txt -stim_label 4 dMN \
	-stim_file 5 sub-"$sub"/Deconvolve/sub-"$sub"_high_Visual_noeyes.txt -stim_label 5 high_Visual \
	-stim_file 6 sub-"$sub"/Deconvolve/sub-"$sub"_Language_noeyes.txt -stim_label 6 Language \
	-stim_file 7 sub-"$sub"/Deconvolve/sub-"$sub"_LECN_noeyes.txt -stim_label 7 LECN \
	-stim_file 8 sub-"$sub"/Deconvolve/sub-"$sub"_post_Salience_noeyes.txt -stim_label 8 post_Salience \
	-stim_file 9 sub-"$sub"/Deconvolve/sub-"$sub"_Precuneus_noeyes.txt -stim_label 9 Precuneus \
	-stim_file 10 sub-"$sub"/Deconvolve/sub-"$sub"_prim_Visual_noeyes.txt -stim_label 10 prim_Visual \
	-stim_file 11 sub-"$sub"/Deconvolve/sub-"$sub"_RECN_noeyes.txt -stim_label 11 RECN \
	-stim_file 12 sub-"$sub"/Deconvolve/sub-"$sub"_Sensorimotor_noeyes.txt -stim_label 12 Sensorimotor \
	-stim_file 13 sub-"$sub"/Deconvolve/sub-"$sub"_vDMN_noeyes.txt -stim_label 13 vDMN \
	-stim_file 14 sub-"$sub"/Deconvolve/sub-"$sub"_Visuospatial_noeyes.txt -stim_label 14 Visuospatial \
	-noFDR -tout -bout -nofullf_atall -nodmbase -nfirst 0 \
	-bucket sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_noeyes.nii.gz

	echo "=================$sub Deconvolve with eyes"
	3dDeconvolve -jobs 6 -float -input sub-"$sub"/Deconvolve/sub-"$sub"_witheyes_errts_wav_sm_MNI.nii.gz -polort -1 -num_stimts 14\
	-stim_file 1 sub-"$sub"/Deconvolve/sub-"$sub"_anterior_Salience_wav.txt -stim_label 1 anterior_Salience \
	-stim_file 2 sub-"$sub"/Deconvolve/sub-"$sub"_Auditory_wav.txt -stim_label 2 Auditory \
	-stim_file 3 sub-"$sub"/Deconvolve/sub-"$sub"_Basal_Ganglia_wav.txt -stim_label 3 Basal_Ganglia \
	-stim_file 4 sub-"$sub"/Deconvolve/sub-"$sub"_dDMN_wav.txt -stim_label 4 dMN \
	-stim_file 5 sub-"$sub"/Deconvolve/sub-"$sub"_high_Visual_wav.txt -stim_label 5 high_Visual \
	-stim_file 6 sub-"$sub"/Deconvolve/sub-"$sub"_Language_wav.txt -stim_label 6 Language \
	-stim_file 7 sub-"$sub"/Deconvolve/sub-"$sub"_LECN_wav.txt -stim_label 7 LECN \
	-stim_file 8 sub-"$sub"/Deconvolve/sub-"$sub"_post_Salience_wav.txt -stim_label 8 post_Salience \
	-stim_file 9 sub-"$sub"/Deconvolve/sub-"$sub"_Precuneus_wav.txt -stim_label 9 Precuneus \
	-stim_file 10 sub-"$sub"/Deconvolve/sub-"$sub"_prim_Visual_wav.txt -stim_label 10 prim_Visual \
	-stim_file 11 sub-"$sub"/Deconvolve/sub-"$sub"_RECN_wav.txt -stim_label 11 RECN \
	-stim_file 12 sub-"$sub"/Deconvolve/sub-"$sub"_Sensorimotor_wav.txt -stim_label 12 Sensorimotor \
	-stim_file 13 sub-"$sub"/Deconvolve/sub-"$sub"_vDMN_wav.txt -stim_label 13 vDMN \
	-stim_file 14 sub-"$sub"/Deconvolve/sub-"$sub"_Visuospatial_wav.txt -stim_label 14 Visuospatial \
	-noFDR -tout -bout -nofullf_atall -nodmbase -nfirst 0 \
	-bucket sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_wav.nii.gz


	echo "=======================extract the coefs"
	for type in noeyes wav
		do
		#seperate the coefficients
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_anterior_Salience_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[0]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_Auditory_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[2]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_Basal_Ganglia_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[4]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_dDMN_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[6]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_high_Visual_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[8]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_Language_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[10]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_LECN_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[12]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_post_Salience_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[14]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_Precuneus_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[16]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_prim_Visual_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[18]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_RECN_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[20]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_Sensorimotor_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[22]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_vDMN_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[24]
		3dbucket -prefix sub-"$sub"/Deconvolve/sub-"$sub"_Visuospatial_"$type"_Coef.nii.gz sub-"$sub"/Deconvolve/sub-"$sub"_drStage2_"$type".nii.gz[26]
	done
	
	#rearrange the files:create a file that contains the all coefficients


done

for network in Auditory Basal_Ganglia dDMN vDMN LECN RECN Language Precuneus anterior_Salience post_Salience Sensorimotor high_Visual prim_Visual Visuospatial
do
	echo "================= create bucket file"
	find . -type f | grep "$network" | grep wav_Coef | sort > FIND/"$network"_list.txt
	find . -type f | grep "$network" | grep noeyes_Coef | sort >> FIND/"$network"_list.txt
	3dbucket -prefix FIND/"$network"_all.nii.gz $(cat FIND/"$network"_list.txt)
	
	#paired t-test with tfce
	#fsl5.0-randomise -i FIND/"$network"_all.nii.gz -o FIND/"$network"_perm_ -d FIND/DRdesign.mat -t FIND/DRdesign.con -e FIND/DRdesign.grp -n 10000 -m mask_res.nii.gz -T
done