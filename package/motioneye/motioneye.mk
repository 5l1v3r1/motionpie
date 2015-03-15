#############################################################
#
# motioneye
#
#############################################################

MOTIONEYE_VERSION = 5b1e856
MOTIONPIE_VERSION = 20150315
MOTIONEYE_SITE = https://bitbucket.org/ccrisan/motioneye/get/
MOTIONEYE_SOURCE = $(MOTIONEYE_VERSION).tar.gz
MOTIONEYE_LICENSE = GPLv3
MOTIONEYE_LICENSE_FILES = LICENCE
MOTIONEYE_INSTALL_TARGET = YES

DST_DIR = $(TARGET_DIR)/programs/motioneye

define MOTIONEYE_INSTALL_TARGET_CMDS
    mkdir -p $(DST_DIR)
    cp -r $(@D)/* $(DST_DIR)/
    cp package/motioneye/update.py $(DST_DIR)/src/
    cp package/motioneye/ipctl.py $(DST_DIR)/src/
    cp package/motioneye/servicectl.py $(DST_DIR)/src/
    cp package/motioneye/watchctl.py $(DST_DIR)/src/
    cp package/motioneye/extractl.py $(DST_DIR)/src/

    # settings
    mv $(DST_DIR)/settings_default.py $(DST_DIR)/settings.py
    sed -i "s%os.path.abspath(os.path.join(PROJECT_PATH, 'conf'))%'/data/etc'%" $(DST_DIR)/settings.py
    sed -i "s%os.path.abspath(os.path.join(PROJECT_PATH, 'run'))%'/tmp'%" $(DST_DIR)/settings.py
    sed -i "s%os.path.abspath(os.path.join(PROJECT_PATH, 'log'))%'/var/log'%" $(DST_DIR)/settings.py
    sed -i "s%os.path.abspath(os.path.join(PROJECT_PATH, 'media'))%'/data/output'%" $(DST_DIR)/settings.py
    sed -i "s%8765%80%" $(DST_DIR)/settings.py
    sed -i "s%WPA_SUPPLICANT_CONF = None%WPA_SUPPLICANT_CONF = '/data/etc/wpa_supplicant.conf'%" $(DST_DIR)/settings.py
    sed -i "s%LOCAL_TIME_FILE = None%LOCAL_TIME_FILE = '/data/etc/localtime'%" $(DST_DIR)/settings.py
    sed -i "s%SMB_SHARES = False%SMB_SHARES = True%" $(DST_DIR)/settings.py
    sed -i "s%SMB_MOUNT_ROOT = '/media'%SMB_MOUNT_ROOT = '/data/media'%" $(DST_DIR)/settings.py
    sed -i "s%ENABLE_REBOOT = False%ENABLE_REBOOT = True%" $(DST_DIR)/settings.py

    # version & name
    sed -r -i "s%VERSION = '[a-bA-B0-9.]+'%VERSION = '$(MOTIONPIE_VERSION)'%" $(DST_DIR)/motioneye.py
    sed -i "s%>motionEye<%>motionPie<%" $(DST_DIR)/templates/main.html
    sed -i "s%}motionEye{%}motionPie{%" $(DST_DIR)/templates/main.html
    sed -i "s%motionEye is up to date%motionPie is up to date%" $(DST_DIR)/static/js/main.js
    sed -i "s%motionEye was successfully updated%motionPie was successfully updated%" $(DST_DIR)/static/js/main.js
    sed -i "s%motioneye-config.tar.gz%motionpie-config.tar.gz%" $(DST_DIR)/src/handlers.py
    sed -i "s%enable_update=False%enable_update=True%" $(DST_DIR)/src/handlers.py
    
    # additional config
    sed -i 's/\(import tzctl .*\)/\1\nimport ipctl\nimport servicectl\nimport watchctl\nimport extractl\ntry:\n    import boardctl\nexcept:\n    pass/' $(DST_DIR)/src/config.py
endef

$(eval $(generic-package))
