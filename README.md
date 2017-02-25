Skylanders.elm
==============

Grab the wiki source: 

`curl http://skylanders.wikia.com/wiki/Senseis -o view-source_skylanders.wikia.com_wiki_Senseis.htm`

Find the images:
` grep scale- view-source_skylanders.wikia.com_wiki_Senseis.htm  | sed 's/.*http:\/\///' | sed 's/".*//' | sed 's/\/^Cscale-.*//' > image-urls
`


vim substitution to generate commands to grab them all:
`:%s/\(.*\/\([^\/]*\.png\)\/revision\/latest\)/curl \1 -o \2/`

Copy and paste that into a terminal

Identify the failures:
`ll -lsr`
`ll -lsr | grep ' 84 ' | awk '{print $10}' | xargs -n1 -I{} grep {} download-all-    images.sh | xargs -n1 -I{} bash -c "{}" `
`ll -lsr | grep ' 1976 ' | awk '{print $10}' | xargs -n1 -I{} grep {} download-all-    images.sh | xargs -n1 -I{} bash -c "{}" `

That file has the character to class and element mappings too:

`grep scale- view-source_skylanders.wikia.com_wiki_Senseis.htm | \
    perl -pe 's|.*img.*?alt="([^"]*).*$|\1|' | \
    grep -v "^$" | \
    perl -pe 's/ Icon$//' | \
    perl -pe 's/ symbol$//' | \
    perl -pe 's/SymbolSkylanders$//' | \
    perl -pe 's/(.*)/"\1"/' | \
    perl -pe "s/(.*)/'\1'/" | \
    xargs -n3 echo > mappings`

Which we format like:
`cat mappings | perl -pe 's/.*?"(.*?)".*?"(.*?)".*?"(.*?)"/Name: \1, Element: \2, Class: \3/'`

And grab the elements:
`cat mappings | perl -pe 's/.*?"(.*?)".*?"(.*?)".*?"(.*?)"/\2/' | sort | uniq | xargs | sed 's/ / | /g' | xargs echo type Element = `

and the battle classes:
`cat mappings | perl -pe 's/.*?"(.*?)".*?"(.*?)".*?"(.*?)"/\3/' | sort | uniq | xargs | sed 's/ / | /g' | xargs echo type BattleClass = `


`cat mappings | perl -pe 's/.*?"(.*?)".*?"(.*?)".*?"(.*?)"/\3/' | sort | uniq | quote | sed 's/"/\\"/g' | xargs | sed 's/ /, /g'`
-> "Bazooker", "Bowslinger", "Brawler", "Kaos", "Knight", "Ninja", "Quickshot", "Sentinel", "Smasher", "Sorcerer", "Swashbuckler"


Annoyingly, 'Kaos' is going to need special treatment. He can't be a top-level class & element :/ 

function value() { echo "$1"; cat - | grep "$1" |  perl -pe 's/.*'"$1"'="(.*?)".*/\1/'; };

function values() {
    while read line;
        do
            xargs echo <(for target in "$@";
                                do
                                    echo $line | value "$target";
                                done;
                        )
		done;
} 


function quote() { sed 's/\(.*\)/"\1"/'; };



```