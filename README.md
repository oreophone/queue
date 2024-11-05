# queue.sh
A small CLI interface for storing and retrieving interesting videos/links. My first shell experience!

## Instructions
In the working directory, add a new file 'links.txt'. The following table uses the alias `queue() {bash PATH/TO/DIR/queue.sh $1 $2}`
| Command | Description |
|--------|---------------|
| queue '(link)' '[desc]' | add link to list with optional description |
| queue -l | list links with indices |
| queue -p | pops the first link from the link to clipboard |
| queue -g [index] | retrieves link at index, default 1 |
| queue -r | retrieves a random link |
| queue -c | clears list |
