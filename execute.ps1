
# powershell -ExecutionPolicy Bypass -File .\execute.ps1

$bits = 256,384,512
$certIndexes = 1..2
$certBits = 512,1024
$inputs = "pippo","pluto","paperino"

function Start-Rsa-Sha-Sign-All {
    foreach ($bit in $bits)
    {
        foreach ($certIndex in $certIndexes)
        {
            foreach ($certBit in $certBits)
            {
                foreach ($input in $inputs) {
                    Start-Rsa-Sha-Sign -Bits $bit -CertIndex $certIndex -CertBits $certBit -InputName $input
                }
            }
        }
    }
}

function Start-Rsa-Sha-Sign {
    param ( 
        [Parameter(Mandatory)]
        [int]$Bits,

        [Parameter(Mandatory)]
        [int]$CertIndex,

        [Parameter(Mandatory)]
        [int]$CertBits,

        [Parameter(Mandatory)]
        [string]$InputName
     )

    $command = "openssl dgst -sha${Bits} -out .\outputs\sha_${Bits}_key_${CertBits}_${CertIndex}_${InputName}_signed.txt -sign .\certificates\private_${CertBits}_${CertIndex}.txt .\inputs\${InputName}_in.txt"
    Invoke-Expression $command
    $command = "openssl enc -base64 -A -in .\outputs\sha_${Bits}_key_${CertBits}_${CertIndex}_${InputName}_signed.txt -out .\outputs\sha_${Bits}_key_${CertBits}_${CertIndex}_${InputName}_signed_base_64.txt"
    Invoke-Expression $command
}

Start-Rsa-Sha-Sign-All
