  packages = [
    "mlocate",
    "net-tools",
    "wget",
    "curl",
    "git",
    "vim",
    #"htop",
    "tree",
    #"stress",
    "python3",
    "nano",
    "whois"
    #"ufw" ## Last line without comma
  ]

[packages].each do |pkg|
  package pkg do
    action :install
    retries 3
    retry_delay 5
  end
end
