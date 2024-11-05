FILE=$(dirname $0)/links.txt

opt_l=false # list
opt_r=false # random
opt_p=false # pop
opt_g=false # get at index
opt_c=false # clear list

if [ $# == 0 ]; then
    cat <<- EOM

    Queue [$(dirname $0)]

    queue (link) [desc] :     add link to list with optional description
    queue -l            :                        list links with indices
    queue -p            : pops the first link from the link to clipboard
    queue -g [index]    :             retrieves link at index, default 1
    queue -r            :                        retrieves a random link
    queue -c            :                                    clears list 

EOM
exit 0
fi

function lines() { wc -l $FILE | awk '{ print $1 }'; }

function checkempty() {
    contents=$(<$FILE)
        if [ -z "${contents}" ]; then
            echo "Queue is empty."
            exit 0
        fi
}

function get() {
    checkempty
    declare -i index=$1
    if [ $# -eq 0 ]; then
        index=1
    fi
    declare -i linesint=$(lines) 
    if (( $index > $linesint )); then
        echo "queue: index too large! [$index < $(lines)]"
        exit 1
    fi
    if (( $index <= 0 )); then
        echo "queue: index is non-positive! [$index]"
        exit 1
    fi
    curline=$(cat $FILE | sed -n "${index}p")
    curdesc=$(echo $curline | grep -o "^'[^']*'")
    curlink=$(echo $curline | grep -o "https:\/\/.*")
    sed -i '' "${index}d" $FILE
    echo "Video $curdesc copied to your clipboard. [$(lines)]"
    echo $curlink | pbcopy
}

while getopts lrpcg opt; do
    case $opt in
        l) opt_l=true ;;
        r) opt_r=true ;;
        p) opt_p=true ;;
        c) opt_c=true ;;
        g) opt_g=true ;;
        *) echo "queue: recieved invalid option ($opt)" >&2
           exit 1;
    esac
done

# list
if $opt_l; then
    checkempty
    declare -i I=0
    while read p; do
        I+=1
        echo "$I: $p"
    done < $FILE
    exit 0
fi
# random
if $opt_r; then
    declare -i linesint=$(lines) 
    get $(( ( RANDOM % $linesint ) + 1 ))
    exit 0
fi

# pop
if $opt_p; then
    get
    exit 0  
fi

# get at index
if $opt_g; then
    get $2
    exit 0
fi

# clear list
if $opt_c; then
    read -p "Clear [$(lines)] items from queue? Y/n " confirm
    if [ $confirm != "Y" ]; then 
        exit 0
    fi
    printf "" > $FILE
    echo "Cleared."
    exit 0
fi

# default: queue

SITE=$1
DESC=$2

if [ ${SITE:0:8} != "https://" ]; then
    echo "queue: link is invalid! ($SITE)"
    exit 1
fi
printf "'$DESC'  $SITE\n" >> $FILE

if [ $# == 1 ]; then
    echo "queue: Added link to queue! [$(lines)]"
    exit 0
fi
echo "queue: Added '$DESC' to queue! [$(lines)]"