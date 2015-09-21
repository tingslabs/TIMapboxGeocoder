#!/usr/bin/env sh

appledoc \
    --company-id com.tingslabs \
    --project-name TIMapboxGeocoder \
    --project-company TingsLabs \
    --project-version 0.2.0 \
    --docset-bundle-id %COMPANYID.%PROJECTID \
    --docset-bundle-name "%PROJECT %VERSION" \
    --docset-bundle-filename %COMPANYID.%PROJECTID-%VERSIONID.docset \
    --ignore "Example" \
    --ignore "docs" \
    --ignore "*.m" \
    --no-repeat-first-par \
    --explicit-crossref \
    --clean-output \
    --keep-intermediate-files \
    --output ./docs \
    .
    
mv docs/docset docs/com.tingslabs.TIMapboxGeocoder-0.2.0.docset
rm docs/docset-installed.txt
