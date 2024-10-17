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
if (-not $rootPath) {
    Write-Error "ROOT_PATH is not set in the .env file."
    exit 1
}

<<<<<<< HEAD
# ディレクトリの作成
New-Item -ItemType Directory -Path $rootPath -Force
New-Item -ItemType Directory -Path "$rootPath/frontend" -Force

# Reactプロジェクトを初期化（Dockerfileを作成する前に）
cd "$rootPath/frontend"
npx create-react-app . --template typescript

# Dockerfileの作成（create-react-app 実行後）
=======
Write-Output "Root path is: $rootPath"

# ディレクトリの作成
New-Item -ItemType Directory -Path $rootPath -Force
New-Item -ItemType Directory -Path "$rootPath/react-frontend" -Force

# Reactプロジェクトを初期化
cd $rootPath
if (-not (Test-Path "$rootPath/react-frontend/package.json")) {
    npx create-react-app react-frontend --template typescript
} else {
    Write-Output "React project already initialized. Skipping 'create-react-app'."
}

# Dockerfileの作成
>>>>>>> f6a4957 (一応動くけど、重い気がする)
$frontendDockerfileContent = @"
# react-frontend
FROM node:20.11.0

WORKDIR /react-frontend

COPY package*.json ./

# NPMのアップデートとタイムアウト設定
RUN npm install -g npm@latest \
    && npm config set fetch-retries 5 \
    && npm config set fetch-retry-factor 10 \
    && npm config set fetch-timeout 600000

RUN npm install

COPY . .

EXPOSE 3000
CMD ["npm", "start"]
"@
<<<<<<< HEAD
Set-Content -Path "$rootPath/frontend/Dockerfile" -Value $frontendDockerfileContent -Force
Write-Output "Dockerfile for frontend has been created."
=======
New-Item -ItemType File -Path "$rootPath/react-frontend/Dockerfile" -Value $frontendDockerfileContent -Force
Write-Output "Dockerfile for react-frontend has been created."
>>>>>>> f6a4957 (一応動くけど、重い気がする)

# docker-compose.ymlの作成
$dockerComposeContent = @"
version: '3.8'
services:
  react-frontend:
    build:
      context: ./react-frontend
      dockerfile: Dockerfile
    container_name: react-frontend
    ports:
      - "3006:3000"
    volumes:
      - ./react-frontend:/react-frontend
    environment:
      - CHOKIDAR_USEPOLLING=true
<<<<<<< HEAD
    stdin_open: true
    tty: true
=======
>>>>>>> f6a4957 (一応動くけど、重い気がする)
"@
Set-Content "$rootPath/docker-compose.yml" -Value $dockerComposeContent -Force
Write-Output "docker-compose.yml has been created."

Write-Output "Project structure has been created and React app initialized."

# Dockerコンテナの起動
cd $rootPath
docker-compose up --build

<<<<<<< HEAD
Write-Output "Directory structure has been created."
=======
Write-Output "Directory structure has been created."
>>>>>>> f6a4957 (一応動くけど、重い気がする)
