Param(
    $NetworkName = "vxlan0",
    $ManagementIP

)
$networkName = $NetworkName.ToLower()

If((Test-Path c:/k/sourceVip.json)) {
    $sourceVipJSON = Get-Content sourceVip.json | ConvertFrom-Json 
    $sourceVip = $sourceVipJSON.ip4.ip.Split("/")[0]
}

$hostMac=(Get-NetAdapter -InterfaceAlias (Get-NetIPAddress -IPAddress $ManagementIP).InterfaceAlias).MacAddress
ipmo c:\k\hns.psm1
Get-HnsPolicyList | Remove-HnsPolicyList
c:\k\kube-proxy.exe --v=4 --proxy-mode=kernelspace --hostname-override=$(hostname) --kubeconfig=c:\k\config --network-name=$networkName --source-vip=$sourceVip --enable-dsr=false
