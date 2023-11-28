﻿FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
#COPY ["PhoneEdit/PhoneEdit.csproj", "PhoneEdit/"]
COPY ["PhoneEdit.csproj", "./"]
RUN dotnet restore "PhoneEdit/PhoneEdit.csproj"
COPY . .
WORKDIR "/src/PhoneEdit"
RUN dotnet build "PhoneEdit.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PhoneEdit.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PhoneEdit.dll"]
