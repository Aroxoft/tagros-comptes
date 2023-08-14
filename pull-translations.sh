#!/bin/sh
# Get all translations from poeditor
# This requires `gojq` and `curl`

# Properties should be located in file `poeditor.properties`
# The file should contain the following properties:
# ```
# poeditor.api_token=<your api token>
# poeditor.project_id=<your project id>
# poeditor.languages=<your languages>
# ```
# The api token and project id can be found in your poeditor account
# The api token can have read-only access
# The languages should be separated by spaces
file="./poeditor.properties"
# if file doesn't exist, then exit
if [ ! -f "$file" ]
then
  echo "$file not found."
  exit 1
fi

while IFS='=' read -r key value
do
  key=$(echo "$key" | tr '.' '_')
  eval "${key}"=\${value}
done < "$file"

API_TOKEN="$poeditor_api_token"
PROJECT_ID="$poeditor_project_id"
LANGS="$poeditor_languages"

# Download all translations
# See https://poeditor.com/docs/api#projects_export
# This will download all translations in the `lib/l10n` folder
# by parsing the JSON response with `gojq` and using `curl` to download the file
for i in $LANGS ; do
  echo "Downloading $i..."
  curl -X POST https://api.poeditor.com/v2/projects/export \
  -d api_token="$API_TOKEN" \
  -d id="$PROJECT_ID" \
  -d language="$i" \
  -d type="arb" \
  -d order="terms" | gojq -r '.result.url' | xargs -I myurl curl myurl --output lib/l10n/intl_"$i".arb && echo "Downloaded to lib/l10n/intl_$i.arb"
done
