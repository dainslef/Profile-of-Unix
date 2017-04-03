# This fish config need to install Oh-My-Fish:
# $ curl -L https://get.oh-my.fish | fish
#
# Fish shell and Oh-My-Fish file directory:
# ~/.local/share/omf
# ~/.local/share/fish
# ~/.cache/omf
# ~/.config/fish



# ------------------------------------------------------------------------------
# --- Function define ---

# Set the default user
function set_default_user
	# Use "set" to create a variable, use "-g" to create a global variable
	set -g default_user $argv[1]
end

# Print the welcome message
function show_welcome

	if test (id -u) -gt 0
		if test (uname) = "Darwin"
			set show_os_version (uname -srnm)
		else if test -n "$DISPLAY"
			set show_os_version (uname -ornm)
		end
	end

	if test -n "$show_os_version" # Print welcome message in macOS or Linux GUI
		echo -ne "\033[1;30m" # Set greet color
		echo (uptime)
		echo " $show_os_version"
		echo --- Welcome, (whoami)! Today is (date +"%B %d %Y, %A"). ---
		switch (random 1 5)
			case 1
				echo -e "--- 夢に描けることなら、実現できる。 ---\n"
			case 2
				echo -e "--- 一日は貴い一生である。これを空費してはならない。 ---\n"
			case 3
				echo -e "--- 世界は美しくなんかない。そしてそれ故に、美しい。 ---\n"
			case 4
				echo -e "--- 春は夜桜、夏には星、秋に満月、冬には雪。 ---\n"
			case 5
				echo -e "--- あなたもきっと、誰かの奇跡。 ---\n"
		end
		echo -ne "\033[0m" # Reset color
	end

end

# Check user, set the custom environment variables
function env_config

	if test (whoami) = $default_user

		# Check OS type and set the different environment variables
		if test (uname) = "Darwin" # Darwin kernel means in macOS

			set vscode "/Users/$default_user/Applications/Develop/Visual\ Studio\ Code.app/Contents/MacOS/Electron"
			set python_version (python3 -V | awk -F' ' '{ print $2 }' | awk -F'.' '{ print $1 "." $2 }')
			set pip_bin ~/Library/Python/$python_version/bin

			# Set environment variable for Homebrew Bottles mirror (use USTC mirror)
			set -xg HOMEBREW_BOTTLE_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles

		else if test (uname) = "Linux"

			set vscode /home/$default_user/Public/VSCode-linux-x64/code
			set pip_bin ~/.local/bin

			# For custom IDE alias in Linux
			alias netbeans ~/Public/netbeans/bin/netbeans
			alias idea ~/Public/idea-IU/bin/idea.sh
			alias eclipse ~/Public/eclipse/eclipse

		end

		# Set scala activator path
		alias activator ~/Public/activator-dist/bin/activator

		# Set visual studio code path
		alias code $vscode

		# Set python pip package path
		if test -e $pip_bin
			set PATH $PATH $pip_bin
		end

		# Set golang path
		# Use "set -x" to create a environment variable
		# Use "-xg" to set this environment variable as a global environment variable
		set -xg GOPATH ~/Public/Go

		# Set language environment
		set -xg LANG en_US.UTF-8
		set -xg LC_ALL en_US.UTF-8

		# Preferred editor for local and remote sessions
		if test -n $SSH_CONNECTION
			set -xg EDITOR "nano"
		else
			set -xg EDITOR "vim"
		end

	end

end

# Set theme color for bobthefish
# Override default greeting at ~/.config/fish/functions/fish_greeting.fish
set theme_color_scheme terminal2

# Run function
set_default_user "dainslef"
show_welcome
env_config

# Delete defined functions and variables
# Use "-e" means to erase a function/variable
set -e DEFAULT_USER
functions -e set_default_user
functions -e show_welcome
functions -e env_config