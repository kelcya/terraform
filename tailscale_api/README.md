# Introduction

Tailscale does not offer a SCIM feature with Okta. If you want to automate the tailscale acl process and want to sync your okta groups to tailscale groups, there is no good way currently. 
See this tailscale issue https://github.com/tailscale/tailscale/issues/979

Until then, the hackaround would be to use terraform with the tailscale api and okta providers to sync okta group members to tailscale.

There is also a jenkins file in case you want to run this as a pipeline.
