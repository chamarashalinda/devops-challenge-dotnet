# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app

# Copy the csproj and restore dependencies
COPY *.sln ./
COPY src/ ./src/
COPY tests/ ./tests/
RUN dotnet restore

# Build the application
WORKDIR /app/src/DevOpsChallenge.SalesApi
RUN dotnet publish -c Release -o /app/out

# Stage 2: Run the application
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose the port the app runs on
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "DevOpsChallenge.SalesApi.dll"]
