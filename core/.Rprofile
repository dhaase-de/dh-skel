# default packages
options(defaultPackages = c(unlist(options("defaultPackages")), "dh"))

# set terminal width
try(options(width = as.numeric(system("tput cols", intern = TRUE))))

# load local R profile file
if (file.exists("~/.Rprofile.local")) {
   source("~/.Rprofile.local")
}
