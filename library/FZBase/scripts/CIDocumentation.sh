export LC_ALL="en_US.UTF-8"
Path=/Users/fuzzbuild/Public/DocumentationServer
DocPath=$Path/$XCS_BOT_NAME
echo "Delete Old Documentation"
rm -rf $DocPath
echo "Build Documentation"
path=$(ls)
echo "Path="
echo $path
headerdoc2html $XCS_SOURCE_DIR/$path/*.h -o "$DocPath"
gatherheaderdoc "$DocPath"
mv "$DocPath/masterTOC.html" "$DocPath/index.html"
