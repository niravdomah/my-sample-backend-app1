FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
COPY . .
RUN dotnet publish my-sample-backend-app1.csproj \
    --source https://api.nuget.org/v3/index.json \
    --source https://nuget.twenty57.com/linx8/api/v3/index.json \
    --verbosity minimal \
    --output publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
COPY --from=build publish ./
ENTRYPOINT ["dotnet", "my-sample-backend-app1.dll"]
