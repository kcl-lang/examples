"""
This is the daemon_set_update_strategy module in k8spkg.api.apps.v1 package.
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""


schema DaemonSetUpdateStrategy:
    """ DaemonSetUpdateStrategy is a struct used to control the update strategy for a DaemonSet.

    Attributes
    ----------
    $type : str, default is Undefined, optional
         Type of daemon set update. Can be "RollingUpdate" or "OnDelete". Default is RollingUpdate.
    rollingUpdate : RollingUpdateDaemonSet, default is Undefined, optional
         Rolling update config params. Present only if type = "RollingUpdate".
    """


    $type?: str

    rollingUpdate?: RollingUpdateDaemonSet


