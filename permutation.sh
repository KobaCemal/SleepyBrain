#input file and zero file must be in the same directory
#Inputs: dataset name(a bucket file containing coefficients of all subjects)

dataset=$1


#Apply the inital test with original data
function initialWilcoxon {
echo "=========================================================INITIAL TEST========================================================="
	dset_name=$(echo "$dataset" | cut -d "." -f 1)
	3dWilcoxon -dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 2 "$dataset"[0] \
	-dset 2 "$dataset"[1] \
	-dset 2 "$dataset"[2] \
	-dset 2 "$dataset"[3] \
	-dset 2 "$dataset"[4] \
	-dset 2 "$dataset"[5] \
	-dset 2 "$dataset"[6] \
	-dset 2 "$dataset"[7] \
	-dset 2 "$dataset"[8] \
	-dset 2 "$dataset"[9] \
	-dset 2 "$dataset"[10] \
	-dset 2 "$dataset"[11] \
	-dset 2 "$dataset"[12] \
	-dset 2 "$dataset"[13] \
	-dset 2 "$dataset"[14] \
	-dset 2 "$dataset"[15] \
	-dset 2 "$dataset"[16] \
	-dset 2 "$dataset"[17] \
	-dset 2 "$dataset"[18] \
	-dset 2 "$dataset"[19] \
	-dset 2 "$dataset"[20] \
	-dset 2 "$dataset"[21] \
	-dset 2 "$dataset"[22] \
	-dset 2 "$dataset"[23] \
	-dset 2 "$dataset"[24] \
	-dset 2 "$dataset"[25] \
	-dset 2 "$dataset"[26] \
	-dset 2 "$dataset"[27] \
	-dset 2 "$dataset"[28] \
	-dset 2 "$dataset"[29] \
	-dset 2 "$dataset"[30] \
	-dset 2 "$dataset"[31] \
	-dset 2 "$dataset"[32] \
	-dset 2 "$dataset"[33] \
	-dset 2 "$dataset"[34] \
	-dset 2 "$dataset"[35] \
	-dset 2 "$dataset"[36] \
	-dset 2 "$dataset"[37] \
	-dset 2 "$dataset"[38] \
	-dset 2 "$dataset"[39] \
	-dset 2 "$dataset"[40] \
	-dset 2 "$dataset"[41] \
	-dset 2 "$dataset"[42] \
	-dset 2 "$dataset"[43] \
	-dset 2 "$dataset"[44] \
	-dset 2 "$dataset"[45] \
	-dset 2 "$dataset"[46] \
	-dset 2 "$dataset"[47] \
	-dset 2 "$dataset"[48] \
	-dset 2 "$dataset"[49] \
	-dset 2 "$dataset"[50] \
	-dset 2 "$dataset"[51] \
	-dset 2 "$dataset"[52] \
	-dset 2 "$dataset"[53] \
	-dset 2 "$dataset"[54] \
	-dset 2 "$dataset"[55] \
	-dset 2 "$dataset"[56] \
	-dset 2 "$dataset"[57] \
	-dset 2 "$dataset"[58] \
	-dset 2 "$dataset"[59] \
	-dset 2 "$dataset"[60] \
	-dset 2 "$dataset"[61] \
	-dset 2 "$dataset"[62] \
	-dset 2 "$dataset"[63] \
	-dset 2 "$dataset"[64] \
	-dset 2 "$dataset"[65] \
	-dset 2 "$dataset"[66] \
	-dset 2 "$dataset"[67] \
	-dset 2 "$dataset"[68] \
	-dset 2 "$dataset"[69] \
	-dset 2 "$dataset"[70] \
	-dset 2 "$dataset"[71] \
	-dset 2 "$dataset"[72] \
	-dset 2 "$dataset"[73] \
	-dset 2 "$dataset"[74] \
	-dset 2 "$dataset"[75] \
	-dset 2 "$dataset"[76] \
	-dset 2 "$dataset"[77] \
	-dset 2 "$dataset"[78] \
	-dset 2 "$dataset"[79] \
	-dset 2 "$dataset"[80] \
	-dset 2 "$dataset"[81] \
	-dset 2 "$dataset"[82] \
	-out "$dset_name"_Wil.nii.gz -workmem 10000
}

## Save the number of voxels of largest cluster of original data (I had to cluster the results with 2 voxels already, it was necessary to save the masks)
function saveOrigClust {
echo "=========================================================SAVING INITIAL RESULTS========================================================="
	3dclust -1Dformat -nosum -1dindex 0 -1tindex 1 -2thresh $thr_min $thr_max -dxyz=1 1.01 "$thr_vox" "$dset_out".nii.gz > origClust_tbl.txt
	cat origClust_tbl.txt  | head -n 6 | tail -n 1 | awk '{print $1}' > origClust_size.txt
}






## Use sample package of R to decide  how many and which subjects' data will be sign flipped. Content of resampler.R is the following:
				

				# #Choose a number from min and max possible sign flips (min and max are not decided here)
				# y <- 40:83

				# # Reorder array, take the first element of reorder y to decide how many sign flips will be applied
				# resY <- sample(y)
				# numFlips <- resY[1]

				# #randomise the order of number of observations
				# order <- 0:82
				# orderRes <- sample(order)

				# #choose first N elements of new order to sign flip, so we know which subjects' data will be flipped
				# toBeFlipped <- orderRes[1:numFlips]

				# write.table(toBeFlipped, file = "chosenOnes.txt", sep = " ")
function  RNG {

	echo "=========================================================RESAMPLING========================================================="
	Rscript resampler.R
	cat chosenOnes.txt | tail -n +2 | awk '{print $2}' | sort -g > chosenOrder.txt
}


## If the subject number is available in the chosen subjects list, flip its sign, otherwise leave it like that
function signFlip {
	
	IFS=$'\n' read -d '' -r -a flippers < chosenOrder.txt

	for vol in {0..82}
	do
		for i in "${flippers[@]}"
		do
		    if [ "$i" -eq "$vol" ] ; then
		        found=1
		    fi
		done
		if [ "$found" == "1" ]; then
			echo "=========================================================FLIPPING VOLUME $vol========================================================="
			3dcalc -a "$dataset"["$vol"] -expr '(a*-1)' -prefix "$dset_name"_"$vol"_flip.nii.gz
		else
			"=========================================================NOT FLIPPING VOLUME $vol========================================================="
			3dcalc -a "$dataset"["$vol"] -expr '(a)' -prefix "$dset_name"_"$vol"_flip.nii.gz
			found=0
		fi
	done
	echo "=========================================================MERGING THE VOLUMES========================================================="
	3dbucket "$dset_name"_*_flip.nii.gz -prefix "$dset_name"_flip.nii.gz 
	echo "=========================================================REMOVING TEMPORARY FILES========================================================="
	rm "$dset_name"_*_flip.nii.gz
}


## Apply another Wilcoxon test on flipped data
function permWilcoxon {
	echo "=========================================================APPLYING PERMUTATION NUMBER $perm========================================================="
	3dWilcoxon -dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 1 zero.nii.gz \
	-dset 2 "$dset_name"_flip.nii.gz[0] \
	-dset 2 "$dset_name"_flip.nii.gz[1] \
	-dset 2 "$dset_name"_flip.nii.gz[2] \
	-dset 2 "$dset_name"_flip.nii.gz[3] \
	-dset 2 "$dset_name"_flip.nii.gz[4] \
	-dset 2 "$dset_name"_flip.nii.gz[5] \
	-dset 2 "$dset_name"_flip.nii.gz[6] \
	-dset 2 "$dset_name"_flip.nii.gz[7] \
	-dset 2 "$dset_name"_flip.nii.gz[8] \
	-dset 2 "$dset_name"_flip.nii.gz[9] \
	-dset 2 "$dset_name"_flip.nii.gz[10] \
	-dset 2 "$dset_name"_flip.nii.gz[11] \
	-dset 2 "$dset_name"_flip.nii.gz[12] \
	-dset 2 "$dset_name"_flip.nii.gz[13] \
	-dset 2 "$dset_name"_flip.nii.gz[14] \
	-dset 2 "$dset_name"_flip.nii.gz[15] \
	-dset 2 "$dset_name"_flip.nii.gz[16] \
	-dset 2 "$dset_name"_flip.nii.gz[17] \
	-dset 2 "$dset_name"_flip.nii.gz[18] \
	-dset 2 "$dset_name"_flip.nii.gz[19] \
	-dset 2 "$dset_name"_flip.nii.gz[20] \
	-dset 2 "$dset_name"_flip.nii.gz[21] \
	-dset 2 "$dset_name"_flip.nii.gz[22] \
	-dset 2 "$dset_name"_flip.nii.gz[23] \
	-dset 2 "$dset_name"_flip.nii.gz[24] \
	-dset 2 "$dset_name"_flip.nii.gz[25] \
	-dset 2 "$dset_name"_flip.nii.gz[26] \
	-dset 2 "$dset_name"_flip.nii.gz[27] \
	-dset 2 "$dset_name"_flip.nii.gz[28] \
	-dset 2 "$dset_name"_flip.nii.gz[29] \
	-dset 2 "$dset_name"_flip.nii.gz[30] \
	-dset 2 "$dset_name"_flip.nii.gz[31] \
	-dset 2 "$dset_name"_flip.nii.gz[32] \
	-dset 2 "$dset_name"_flip.nii.gz[33] \
	-dset 2 "$dset_name"_flip.nii.gz[34] \
	-dset 2 "$dset_name"_flip.nii.gz[35] \
	-dset 2 "$dset_name"_flip.nii.gz[36] \
	-dset 2 "$dset_name"_flip.nii.gz[37] \
	-dset 2 "$dset_name"_flip.nii.gz[38] \
	-dset 2 "$dset_name"_flip.nii.gz[39] \
	-dset 2 "$dset_name"_flip.nii.gz[40] \
	-dset 2 "$dset_name"_flip.nii.gz[41] \
	-dset 2 "$dset_name"_flip.nii.gz[42] \
	-dset 2 "$dset_name"_flip.nii.gz[43] \
	-dset 2 "$dset_name"_flip.nii.gz[44] \
	-dset 2 "$dset_name"_flip.nii.gz[45] \
	-dset 2 "$dset_name"_flip.nii.gz[46] \
	-dset 2 "$dset_name"_flip.nii.gz[47] \
	-dset 2 "$dset_name"_flip.nii.gz[48] \
	-dset 2 "$dset_name"_flip.nii.gz[49] \
	-dset 2 "$dset_name"_flip.nii.gz[50] \
	-dset 2 "$dset_name"_flip.nii.gz[51] \
	-dset 2 "$dset_name"_flip.nii.gz[52] \
	-dset 2 "$dset_name"_flip.nii.gz[53] \
	-dset 2 "$dset_name"_flip.nii.gz[54] \
	-dset 2 "$dset_name"_flip.nii.gz[55] \
	-dset 2 "$dset_name"_flip.nii.gz[56] \
	-dset 2 "$dset_name"_flip.nii.gz[57] \
	-dset 2 "$dset_name"_flip.nii.gz[58] \
	-dset 2 "$dset_name"_flip.nii.gz[59] \
	-dset 2 "$dset_name"_flip.nii.gz[60] \
	-dset 2 "$dset_name"_flip.nii.gz[61] \
	-dset 2 "$dset_name"_flip.nii.gz[62] \
	-dset 2 "$dset_name"_flip.nii.gz[63] \
	-dset 2 "$dset_name"_flip.nii.gz[64] \
	-dset 2 "$dset_name"_flip.nii.gz[65] \
	-dset 2 "$dset_name"_flip.nii.gz[66] \
	-dset 2 "$dset_name"_flip.nii.gz[67] \
	-dset 2 "$dset_name"_flip.nii.gz[68] \
	-dset 2 "$dset_name"_flip.nii.gz[69] \
	-dset 2 "$dset_name"_flip.nii.gz[70] \
	-dset 2 "$dset_name"_flip.nii.gz[71] \
	-dset 2 "$dset_name"_flip.nii.gz[72] \
	-dset 2 "$dset_name"_flip.nii.gz[73] \
	-dset 2 "$dset_name"_flip.nii.gz[74] \
	-dset 2 "$dset_name"_flip.nii.gz[75] \
	-dset 2 "$dset_name"_flip.nii.gz[76] \
	-dset 2 "$dset_name"_flip.nii.gz[77] \
	-dset 2 "$dset_name"_flip.nii.gz[78] \
	-dset 2 "$dset_name"_flip.nii.gz[79] \
	-dset 2 "$dset_name"_flip.nii.gz[80] \
	-dset 2 "$dset_name"_flip.nii.gz[81] \
	-dset 2 "$dset_name"_flip.nii.gz[82] \
	-out "$dset_name"_Wil_perm.nii.gz -workmem 10000
}

## Save the largest cluster of the flipped data
function savePermClust {
	echo "=========================================================SAVING THE RESULTS OF PERMUTATION $perm========================================================="
	3dclust -1Dformat -nosum -1dindex 0 -1tindex 1 -2thresh $thr_min $thr_max -dxyz=1 1.01 "$thr_vox" "$dset_name"_Wil_perm.nii.gz > permClust_tbl.txt
	cat permClust_tbl.txt  | head -n 6 | tail -n 1 | awk '{print $1}' >> permClust_sizes.txt
}


## Script starts here

initialWilcoxon $dataset
saveOrigClust $thr_min $thr_max $thr_vox

for perm in {1.."$num_perms"}
do
	RNG
	signFlip
	permWilcoxon
	savePermClust
	rm "$dset_name"_Wil_perm.nii.gz
done