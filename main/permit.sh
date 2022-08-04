#!/bin/bash


chmod 771 OmegaBank
setfacl -R -m g:CEO:rwx OmegaBank


cd OmegaBank

for branch in Branch1 Branch2 Branch3 Branch4
do
    setfacl -R -m g:"${branch}MGR":rwx ${branch}
    
    chmod 771 ${branch}
    cd ${branch}
    for file in $(ls . | head -n -3)
    do 

        setfacl -m g:"${file}":r-x ${file}
        chmod 771 ${file}
    done
    cd ..
done

cd ..


