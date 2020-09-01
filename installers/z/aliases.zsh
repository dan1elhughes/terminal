# Not really related to Z, but it's about changing directories.
# Input: up 3
# Result: cd ../../../
function up() {
  cd $(printf "%0.0s../" $(seq 1 $1));
}
