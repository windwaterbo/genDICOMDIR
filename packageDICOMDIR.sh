#!/bin/bash
base="../dicom_set/C3L-00395/03-10-2003-CT-ABDOMEN-NONENH-ENHANCEDAB-69408"
IFS=$'\n'
dirs=($(find ${base} -maxdepth 1 -mindepth 1))
targetBase="../dicom_set/8_series"
targetDir="${targetBase}/DICOM/"
targetDICOMDIR="${targetBase}/DICOMDIR"

for ((idx=1; idx<=${#dirs[@]}; ++idx)); do
  # get the last word by split "-"" and remove the last char 
  group=${${${dirs[idx]}##*-}%?}
  for file in $(ls "${dirs[idx]}" -f) ; 
  do
    IN="$file"   
    fileName=(${IN//.dcm/})
    trimfileName="$(echo -e "${file}" | tr -d '[:space:]')"
    getNum=${trimfileName//[^1-9]/}
    newfileName="${group}$getNum"
    cp "${dirs[idx]}/$file" "$targetDir$newfileName"
  done
done

cd "${targetBase}"
dcmmkdir +I +r +Ipi -Nxc -Nec -Nrc --output-file  "${targetDICOMDIR}"  DICOM/