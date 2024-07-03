#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["ClockHandsAngleApp2/ClockHandsAngleApp2.csproj", "ClockHandsAngleApp2/"]
COPY ["ClockHandsAngleApp2.Client/ClockHandsAngleApp2.Client.csproj", "ClockHandsAngleApp2.Client/"]
RUN dotnet restore "./ClockHandsAngleApp2/ClockHandsAngleApp2.csproj"
COPY . .
WORKDIR "/src/ClockHandsAngleApp2"
RUN dotnet build "./ClockHandsAngleApp2.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./ClockHandsAngleApp2.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ClockHandsAngleApp2.dll"]