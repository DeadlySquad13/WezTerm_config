-- Always use the local native domain to avoid running via WSL
--   when using `default_domain`.
return {
  {
    label = 'PowerShell',
    -- Powershell 5.x:
    -- args = { 'powershell.exe', '-NoLogo' },
    -- Powershell 7.x:
    args = { 'pwsh.exe', '-NoLogo' },
    domain = { DomainName = 'local' },
  },
  {
    label = 'Cmd',
    args = { 'cmd.exe' },
    domain = { DomainName = 'local' },
  }
}
