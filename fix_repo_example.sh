fix_repo() {
	repo sync .
	Fetching projects: 100% (1/1), done.  
	src/com/android/camera/PanoramaActivity.java: needs merge
	src/com/android/camera/VideoCamera.java: needs merge
	error: you need to resolve your current index first
	
	error: packages/apps/Camera/: CyanogenMod/android_packages_apps_Camera checkout 285b1c5617e2578b86396915fd8037eb16825779 
	git status .
 # Not currently on any branch.
 # Unmerged paths:
 #   (use "git reset HEAD <file>..." to unstage)
 #   (use "git add/rm <file>..." as appropriate to mark resolution)
 #
 #       both modified:      src/com/android/camera/PanoramaActivity.java
 #       both modified:      src/com/android/camera/VideoCamera.java
 #
	no changes added to commit (use "git add" and/or "git commit -a")
	
	git reset HEAD src/com/android/camera/PanoramaActivity.java
	Unstaged changes after reset:
	M       src/com/android/camera/PanoramaActivity.java
	U       src/com/android/camera/VideoCamera.java
	
	git reset HEAD src/com/android/camera/VideoCamera.java
	Unstaged changes after reset:
	M       src/com/android/camera/PanoramaActivity.java
	M       src/com/android/camera/VideoCamera.java
	
	git rm src/com/android/camera/PanoramaActivity.java
	git rm src/com/android/camera/VideoCamera.java
}
