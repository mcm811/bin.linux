github_howto() {
	git config --global user.name "mcm811"
	git config --global user.email "changmin811@gmail.com"

	git config --global credential.helper cache
	git config --global credential.helper 'cache --timeout=3600'

# Create a new repository on the command line
	touch README.md
	git init
	git add README.md
	git commit -m "first commit"
	git remote add origin https://github.com/mcm811/Dorimanx-SG2-I9100-Kernel.git
	git push -u origin master

# Push an existing repository from the command line
	git remote add origin https://github.com/mcm811/Dorimanx-SG2-I9100-Kernel.git
	git push -u origin master

# Duplicating a repo
	git clone --bare git://github.com/dorimanx/Dorimanx-SG2-I9100-Kernel.git
	cd Dorimanx-SG2-I9100-Kernel.git
	git push --mirror https://github.com/mcm811/Dorimanx-SG2-I9100-Kernel.git
	cd ..
	rm -rf Dorimanx-SG2-I9100-Kernel.git
}
