param (
    [Parameter(Mandatory = $true)]
    [string]$rutaArchivo,

    [Parameter(Mandatory = $true)]
    [string]$hashEsperado,

    [Parameter(Mandatory = $true)]
    [ValidateSet("MD5", "SHA1", "SHA256", "SHA512")]
    [string]$algoritmo
)

# Tabla de mapeo de algoritmo a nombre de hash para certutil
$mapeoAlgoritmoCertutil = @{
    "MD5"    = "MD5"
    "SHA1"   = "SHA1"
    "SHA256" = "SHA256"
    "SHA512" = "SHA512"
}

# Verificar que el archivo exista
if (-Not (Test-Path -Path $rutaArchivo)) {
    Write-Error "El archivo especificado no existe: $rutaArchivo"
    exit 1
}

# Calcular el hash del archivo usando certutil y el algoritmo especificado
$salidaCertutil = certutil -hashfile $rutaArchivo $mapeoAlgoritmoCertutil[$algoritmo]
$hashCalculado = ($salidaCertutil | Select-String -Pattern "^[0-9a-f]{32}$|^[0-9a-f]{40}$|^[0-9a-f]{64}$|^[0-9a-f]{128}$").Matches.Value

# Comparar el hash calculado con el hash esperado
if ($hashCalculado -eq $hashEsperado) {
    Write-Output "El hash $algoritmo coincide: $hashCalculado"
    exit 0
}
else {
    Write-Output "El hash $algoritmo no coincide. Esperado: $hashEsperado, Calculado: $hashCalculado"
    exit 1
}