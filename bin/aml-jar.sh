#!/bin/bash
cd ../
java -jar lib/aml-1.0.jar -DWorkDay=20190101 -tcsv -f"/alidata/workspace/aml/work/"
cd work
tar -czvf aml.tar.gz *.csv
rm -rf /alidata/workspace/aml/work/*.csv
cd ../bin