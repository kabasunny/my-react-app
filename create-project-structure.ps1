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
New-Item -ItemType Directory -Path "$rootPath/frontend" -Force


# Reactプロジェクトを初期化
cd $rootPath
npx create-react-app frontend --template typescript

# Dockerfileの作成
$frontendDockerfileContent = @"
FROM node:20.11.0

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000
CMD ["npm", "start"]

"@
New-Item -ItemType File -Path "$rootPath/frontend/Dockerfile" -Value $frontendDockerfileContent -Force
Write-Output "Dockerfile for frontend has been created."

# docker-compose.ymlの作成
$dockerComposeContent = @"
# docker-compose.yml
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - '3000:3000'
    volumes:
      - ./frontend:/usr/src/app
    environment:
      - CHOKIDAR_USEPOLLING=true
    stdin_open: true
    tty: true

"@
Set-Content "$rootPath/docker-compose.yml" -Value $dockerComposeContent -Force
Write-Output "docker-compose.yml has been created."

Write-Output "Project structure has been created and React app initialized."

# Dockerコンテナの起動
docker-compose up --build

Write-Output "Directory structure has been created."

# .\create-project-structure.ps1