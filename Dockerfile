FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /App

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /App/out .

# Configure for HTTPS
ENV ASPNETCORE_URLS="https://+:8081;http://+:8080"
ENV ASPNETCORE_HTTPS_PORT=8081
# Development certificate setup - for production use proper certificates
RUN mkdir -p /https && \
    apt-get update && \
    apt-get install -y --no-install-recommends openssl && \
    openssl req -new -x509 -nodes -days 365 -subj "/CN=localhost" -out /https/aspnetapp.crt -keyout /https/aspnetapp.key && \
    chmod 644 /https/aspnetapp.* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV ASPNETCORE_Kestrel__Certificates__Default__Path=/https/aspnetapp.crt
ENV ASPNETCORE_Kestrel__Certificates__Default__KeyPath=/https/aspnetapp.key

EXPOSE 8080
EXPOSE 8081

ENTRYPOINT ["dotnet", "UeWeb.dll"] 