{ ... }:
{
  environment.etc.issue.text = (builtins.readFile ./issue);
  users.motd = (builtins.readFile ./issue);
}
