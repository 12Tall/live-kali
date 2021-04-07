# The login password is stored in "/media/kali/????????/Windows/System32/config/SAM"

# 0x01 cd to "/media/.../config/"

ls SAM  # SAM

chntpw -l SAM  # list all users

chntpw -u UserName SAM  # Open the detailed User information
  1  # Clear user password
  q  # quit
  y  # save changes

# done.
