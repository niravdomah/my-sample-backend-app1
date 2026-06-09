# syntax=docker/dockerfile:1

# ---- Build stage ----
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Restore (cached separately from source for faster rebuilds)
COPY my-sample-backend-app1.csproj ./
RUN dotnet restore my-sample-backend-app1.csproj

# Build and publish
COPY . .
RUN dotnet publish my-sample-backend-app1.csproj -c Release -o /app/publish --no-restore

# ---- Runtime stage ----
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app

# Run as the non-root user shipped in the base image
USER $APP_UID

# ASP.NET Core listens on 8080 by default in containers (.NET 8+)
EXPOSE 8080
ENV ASPNETCORE_HTTP_PORTS=8080

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "my-sample-backend-app1.dll"]
