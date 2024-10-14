# .env ファイルのパス
$envFilePath = ".env"

# .env ファイルの読み込み
if (Test-Path $envFilePath) {
    Get-Content $envFilePath | ForEach-Object {
        # 空行やコメント行を無視
        if ($_ -match "^\s*#") { return }
        if ($_ -match "^\s*$") { return }
        # 環境変数を設定
        $name, $value = $_ -split "=", 2
        $name = $name.Trim()
        $value = $value.Trim()
        [System.Environment]::SetEnvironmentVariable($name, $value)
    }
}

# 環境変数を使用
$rootPath = $env:ROOT_PATH
Write-Output "Root path is: $rootPath"


# ディレクトリの作成
New-Item -ItemType Directory -Path $rootPath -Force
New-Item -ItemType Directory -Path "$rootPath/api" -Force
New-Item -ItemType Directory -Path "$rootPath/frontend" -Force
New-Item -ItemType Directory -Path "$rootPath/frontend/public" -Force
New-Item -ItemType Directory -Path "$rootPath/frontend/src" -Force

# 空のファイルを作成
New-Item -ItemType File -Path "$rootPath/frontend/package.json" -Force
New-Item -ItemType File -Path "$rootPath/frontend/package-lock.json" -Force
New-Item -ItemType File -Path "$rootPath/frontend/public/index.html" -Force
New-Item -ItemType File -Path "$rootPath/frontend/src/index.tsx" -Force
New-Item -ItemType File -Path "$rootPath/docker-compose.yml" -Force
New-Item -ItemType File -Path "$rootPath/.env" -Force
New-Item -ItemType File -Path "$rootPath/.gitignore" -Force

Write-Output "Directory structure has been created."
