<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:user="urn:my-scripts"
  exclude-result-prefixes="xsl msxsl user"
  version="1.0">
  
  <xsl:output method="xml" indent="no" />
 
  <msxsl:script language="C#" implements-prefix="user">
    <msxsl:assembly name="System.Web" />
    <msxsl:using namespace="System" />
    <msxsl:using namespace="System.Web" />
    <![CDATA[
    public string GetRelativePath(string from, string to)
    {
      try
      {
        var current = Environment.CurrentDirectory;
        from = System.IO.Path.Combine(current, from.Replace('\\', '/'));
        to = System.IO.Path.Combine(current, to.Replace('\\', '/'));
        return (new Uri(from).MakeRelativeUri(new Uri(to)))
          .ToString().Replace('/', '\\');
      }
      catch (Exception ex)
      {
        return ex.Message;
      }
    }
    ]]>
  </msxsl:script> 
 
  <xsl:template match="/">
  
    <xsl:variable
      name="project"
      select="/Input/Projects/Project[@Name=/Input/Generation/ProjectName]" />
  
    <Project 
      DefaultTargets="Build"
      ToolsVersion="4.0"
      xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
      
      <PropertyGroup>
        <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
        <xsl:choose>
          <xsl:when test="/Input/Properties/ForceArchitecture">
            <Platform Condition=" '$(Platform)' == '' "><xsl:value-of select="/Input/Properties/ForceArchitecture" /></Platform>
          </xsl:when>
          <xsl:otherwise>
            <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
          </xsl:otherwise>
        </xsl:choose>
        <ProductVersion>10.0.0</ProductVersion>
        <SchemaVersion>2.0</SchemaVersion>
        <ProjectGuid>{<xsl:value-of select="$project/@Guid" />}</ProjectGuid>
        <xsl:choose>
          <xsl:when test="$project/@Type = 'Website'">            
            <ProjectTypeGuids>
              <xsl:text>{349C5851-65DF-11DA-9384-00065B846F21};</xsl:text>
              <xsl:text>{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}</xsl:text>
            </ProjectTypeGuids>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
        <OutputType>
          <xsl:choose>
            <xsl:when test="$project/@Type = 'XNA'">
              <xsl:text>Exe</xsl:text>
            </xsl:when>
            <xsl:when test="$project/@Type = 'Console'">
              <xsl:text>Exe</xsl:text>
            </xsl:when>
            <xsl:when test="$project/@Type = 'GUI'">
              <xsl:text>WinExe</xsl:text>
            </xsl:when>
            <xsl:when test="$project/@Type = 'GTK'">
              <xsl:text>WinExe</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Library</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </OutputType>
        <RootNamespace>
          <xsl:value-of select="$project/@Name" />
        </RootNamespace>
        <AssemblyName>
          <xsl:value-of select="$project/@Name" />
        </AssemblyName>
      </PropertyGroup>
      <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
        <DebugSymbols>true</DebugSymbols>
        <DebugType>full</DebugType>
        <Optimize>false</Optimize>
        <OutputPath>
          <xsl:choose>
            <xsl:when test="$project/@Type = 'Website'">
              <xsl:text>bin</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>bin\Debug</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </OutputPath>
        <DefineConstants>
          <xsl:text>DEBUG;</xsl:text>
          <xsl:choose>
            <xsl:when test="/Input/Generation/Platform = 'Linux'">
              <xsl:text>PLATFORM_LINUX</xsl:text>
            </xsl:when>
            <xsl:when test="/Input/Generation/Platform = 'Windows'">
              <xsl:text>PLATFORM_WINDOWS</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>PLATFORM_UNKNOWN</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>;</xsl:text>
        </DefineConstants>
        <ErrorReport>prompt</ErrorReport>
        <WarningLevel>4</WarningLevel>
        <xsl:choose>
          <xsl:when test="/Input/Properties/ForceArchitecture">
            <PlatformTarget><xsl:value-of select="/Input/Properties/ForceArchitecture" /></PlatformTarget>
          </xsl:when>
          <xsl:otherwise>
            <PlatformTarget>AnyCPU</PlatformTarget>
          </xsl:otherwise>
        </xsl:choose>
      </PropertyGroup>
      <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
        <DebugType>full</DebugType>
        <Optimize>true</Optimize>
        <OutputPath>
          <xsl:choose>
            <xsl:when test="$project/@Type = 'Website'">
              <xsl:text>bin</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>bin\Release</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </OutputPath>
        <DefineConstants>
          <xsl:text>RELEASE;</xsl:text>
          <xsl:choose>
            <xsl:when test="/Input/Generation/Platform = 'Linux'">
              <xsl:text>PLATFORM_LINUX</xsl:text>
            </xsl:when>
            <xsl:when test="/Input/Generation/Platform = 'Windows'">
              <xsl:text>PLATFORM_WINDOWS</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>PLATFORM_UNKNOWN</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>;</xsl:text>
        </DefineConstants>
        <ErrorReport>prompt</ErrorReport>
        <WarningLevel>4</WarningLevel>
        <xsl:choose>
          <xsl:when test="/Input/Properties/ForceArchitecture">
            <PlatformTarget><xsl:value-of select="/Input/Properties/ForceArchitecture" /></PlatformTarget>
          </xsl:when>
          <xsl:otherwise>
            <PlatformTarget>AnyCPU</PlatformTarget>
          </xsl:otherwise>
        </xsl:choose>
      </PropertyGroup>
      <xsl:if test="/Input/Properties/ForceArchitecture">
        <PropertyGroup>
          <xsl:attribute name="Condition">
            <xsl:text> '$(Configuration)|$(Platform)' == 'Debug|</xsl:text>
            <xsl:value-of select="/Input/Properties/ForceArchitecture" />
            <xsl:text>' </xsl:text>
          </xsl:attribute>
          <DebugSymbols>true</DebugSymbols>
          <DebugType>full</DebugType>
          <Optimize>false</Optimize>
          <OutputPath>
            <xsl:choose>
              <xsl:when test="$project/@Type = 'Website'">
                <xsl:text>bin</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>bin\Debug</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </OutputPath>
          <DefineConstants>
            <xsl:text>DEBUG;</xsl:text>
            <xsl:choose>
              <xsl:when test="/Input/Generation/Platform = 'Linux'">
                <xsl:text>PLATFORM_LINUX</xsl:text>
              </xsl:when>
              <xsl:when test="/Input/Generation/Platform = 'Windows'">
                <xsl:text>PLATFORM_WINDOWS</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>PLATFORM_UNKNOWN</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>;</xsl:text>
          </DefineConstants>
          <ErrorReport>prompt</ErrorReport>
          <WarningLevel>4</WarningLevel>
          <xsl:choose>
            <xsl:when test="/Input/Properties/ForceArchitecture">
              <PlatformTarget><xsl:value-of select="/Input/Properties/ForceArchitecture" /></PlatformTarget>
            </xsl:when>
            <xsl:otherwise>
              <PlatformTarget>AnyCPU</PlatformTarget>
            </xsl:otherwise>
          </xsl:choose>
        </PropertyGroup>
        <PropertyGroup>
          <xsl:attribute name="Condition">
            <xsl:text> '$(Configuration)|$(Platform)' == 'Release|</xsl:text>
            <xsl:value-of select="/Input/Properties/ForceArchitecture" />
            <xsl:text>' </xsl:text>
          </xsl:attribute>
          <DebugType>full</DebugType>
          <Optimize>true</Optimize>
          <OutputPath>
            <xsl:choose>
              <xsl:when test="$project/@Type = 'Website'">
                <xsl:text>bin</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>bin\Release</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </OutputPath>
          <DefineConstants>
            <xsl:text>RELEASE;</xsl:text>
            <xsl:choose>
              <xsl:when test="/Input/Generation/Platform = 'Linux'">
                <xsl:text>PLATFORM_LINUX</xsl:text>
              </xsl:when>
              <xsl:when test="/Input/Generation/Platform = 'Windows'">
                <xsl:text>PLATFORM_WINDOWS</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>PLATFORM_UNKNOWN</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>;</xsl:text>
          </DefineConstants>
          <ErrorReport>prompt</ErrorReport>
          <WarningLevel>4</WarningLevel>
          <xsl:choose>
            <xsl:when test="/Input/Properties/ForceArchitecture">
              <PlatformTarget><xsl:value-of select="/Input/Properties/ForceArchitecture" /></PlatformTarget>
            </xsl:when>
            <xsl:otherwise>
              <PlatformTarget>AnyCPU</PlatformTarget>
            </xsl:otherwise>
          </xsl:choose>
        </PropertyGroup>
      </xsl:if>
      
      
      <xsl:if test="/Input/Generation/UseCSCJVM = 'True'">
        <PropertyGroup>
          <CscToolExe>
            <xsl:text>$(SolutionDir)\Libraries\cscjvm\</xsl:text>
            <xsl:text>cscjvm\bin\Debug\cscjvm.exe</xsl:text>
          </CscToolExe>
        </PropertyGroup>
      </xsl:if>

      <Import Project="$(MSBuildBinPath)\Microsoft.CSharp.targets" />      
      <xsl:choose>
        <xsl:when test="$project/@Type = 'Website'">    
          <Import>
            <xsl:attribute name="Project">
              <xsl:text>$(MSBuildExtensionsPath)\Microsoft\</xsl:text>
              <xsl:text>VisualStudio\v10.0\WebApplications\</xsl:text>
              <xsl:text>Microsoft.WebApplication.targets</xsl:text>
            </xsl:attribute>
          </Import>
          <Import>
            <xsl:attribute name="Project">
              <xsl:text>..\packages\</xsl:text>
              <xsl:text>RazorGenerator.MsBuild.2.0.1\tools\</xsl:text>
              <xsl:text>RazorGenerator.targets</xsl:text>
            </xsl:attribute>
          </Import>
          <Target Name="BeforeBuild">
            <CallTarget Targets="PrecompileRazorFiles" />
          </Target>
        </xsl:when>
      </xsl:choose>
      
      <xsl:if test="$project/@Type = 'GTK'">
        <ItemGroup>
          <Reference Include="gtk-sharp, Version=2.4.0.0, Culture=neutral, PublicKeyToken=35e10195dab3c99f">
            <SpecificVersion>False</SpecificVersion>
          </Reference>
          <Reference Include="gdk-sharp, Version=2.4.0.0, Culture=neutral, PublicKeyToken=35e10195dab3c99f">
            <SpecificVersion>False</SpecificVersion>
          </Reference>
          <Reference Include="glib-sharp, Version=2.4.0.0, Culture=neutral, PublicKeyToken=35e10195dab3c99f">
            <SpecificVersion>False</SpecificVersion>
          </Reference>
          <Reference Include="glade-sharp, Version=2.4.0.0, Culture=neutral, PublicKeyToken=35e10195dab3c99f">
            <SpecificVersion>False</SpecificVersion>
          </Reference>
          <Reference Include="pango-sharp, Version=2.4.0.0, Culture=neutral, PublicKeyToken=35e10195dab3c99f">
            <SpecificVersion>False</SpecificVersion>
          </Reference>
          <Reference Include="atk-sharp, Version=2.4.0.0, Culture=neutral, PublicKeyToken=35e10195dab3c99f">
            <SpecificVersion>False</SpecificVersion>
          </Reference>
        </ItemGroup>
      </xsl:if>
      
      <ItemGroup>
        <xsl:for-each select="$project/References/Reference">
          <xsl:variable name="include-path" select="./@Include" />
          <xsl:if test="
            count(/Input/Projects/Project[@Name=$include-path]) = 0">
            <xsl:if test="
              count(/Input/Projects/ExternalProject[@Name=$include-path]) = 0">
              <xsl:if test="
                count(/Input/Projects/ContentProject[@Name=$include-path]) = 0">

                <Reference>
                  <xsl:attribute name="Include">
                    <xsl:value-of select="@Include" />
                  </xsl:attribute>
                  <xsl:text />
                </Reference>
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </ItemGroup>
      
      <ItemGroup>
        <xsl:for-each select="$project/References/Reference">
          <xsl:variable name="include-name" select="./@Include" />
          <xsl:if test="
            count(/Input/Projects/Project[@Name=$include-name]) = 0">
            <xsl:if test="
              count(/Input/Projects/ExternalProject[@Name=$include-name]) > 0">

              <xsl:variable name="extern"
                select="/Input/Projects/ExternalProject[@Name=$include-name]" />
            
              <xsl:for-each select="$extern/Binary">
                <Reference>
                  <xsl:attribute name="Include">
                    <xsl:value-of select="@Name" />
                  </xsl:attribute>
                  <HintPath>
                    <xsl:value-of
                      select="user:GetRelativePath(
                        concat(
                          $project/@Path,
                          '\',
                          $project/@Name,
                          '.',
                          /Input/Generation/Platform,
                          '.csproj'),
                        @Path)" />
                  </HintPath>
                </Reference>
              </xsl:for-each>
              <xsl:for-each select="$extern/Platform
                                      [@Type=/Input/Generation/Platform]">
                <xsl:for-each select="./Binary">
                  <Reference>
                    <xsl:attribute name="Include">
                      <xsl:value-of select="@Name" />
                    </xsl:attribute>
                    <HintPath>
                      <xsl:value-of
                        select="user:GetRelativePath(
                          concat(
                            $project/@Path,
                            '\',
                            $project/@Name,
                            '.',
                            /Input/Generation/Platform,
                            '.csproj'),
                          @Path)" />
                    </HintPath>
                  </Reference>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </ItemGroup>
      
      <ItemGroup>
        <xsl:for-each select="/Input/NuGet/Package">
          <Reference>
            <xsl:attribute name="Include">
              <xsl:value-of select="@Name" />
            </xsl:attribute>
            <HintPath>
              <xsl:value-of
                select="user:GetRelativePath(
                  concat(
                    $project/@Path,
                    '\',
                    $project/@Name,
                    '.',
                    /Input/Generation/Platform,
                    '.csproj'),
                  .)" />
            </HintPath>
          </Reference>
        </xsl:for-each>
      </ItemGroup>
      
      <ItemGroup>
        <xsl:for-each select="$project/Files/Compile">
          <xsl:element 
            name="{name()}" 
            namespace="http://schemas.microsoft.com/developer/msbuild/2003">
            <xsl:attribute name="Include">
              <xsl:value-of select="@Include" />
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
          </xsl:element>
        </xsl:for-each>
      </ItemGroup>
      
      <ItemGroup>
        <xsl:for-each select="$project/Files/None">
          <xsl:element 
            name="{name()}" 
            namespace="http://schemas.microsoft.com/developer/msbuild/2003">
            <xsl:attribute name="Include">
              <xsl:value-of select="@Include" />
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
          </xsl:element>
        </xsl:for-each>
      </ItemGroup>
      
      <ItemGroup>
        <xsl:for-each select="$project/Files/Content">
          <xsl:element 
            name="{name()}" 
            namespace="http://schemas.microsoft.com/developer/msbuild/2003">
            <xsl:attribute name="Include">
              <xsl:value-of select="@Include" />
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
          </xsl:element>
        </xsl:for-each>
      </ItemGroup>
      
      <ItemGroup>
        <xsl:for-each select="$project/Files/EmbeddedResource">
          <xsl:element 
            name="{name()}" 
            namespace="http://schemas.microsoft.com/developer/msbuild/2003">
            <xsl:attribute name="Include">
              <xsl:value-of select="@Include" />
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
          </xsl:element>
        </xsl:for-each>
      </ItemGroup>
      
      <ItemGroup>
        <xsl:for-each select="$project/References/Reference">
          <xsl:variable name="include-path" select="./@Include" />
          <xsl:if test="
            count(/Input/Projects/ContentProject[@Name=$include-path]) > 0">

            <xsl:for-each select="/Input
                                  /Projects
                                  /ContentProject[@Name=$include-path]
                                  /Compiled">
              <None>
                <xsl:attribute name="Include">
                  <xsl:value-of
                    select="user:GetRelativePath(
                      concat(
                        /Input/Generation/RootPath,
                        $project/@Path,
                        '\',
                        $project/@Name,
                        '.',
                        /Input/Generation/Platform,
                        '.csproj'),
                      current()/FullPath)" />
                </xsl:attribute>
                <Link>
                  <xsl:value-of select="current()/RelativePath" />
                </Link>
                <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
              </None>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
      </ItemGroup>
   
      <xsl:if test="$project/@Type = 'Tests'">
      	<UsingTask
          TaskName="Xunit.Runner.MSBuild.xunit">
          <xsl:attribute name="AssemblyFile">
          	<xsl:value-of select="concat(
/Input/Generation/RootPath,
'packages/xunit.runners.1.9.1/tools/xunit.runner.msbuild.dll')" />
          </xsl:attribute>
        </UsingTask>
        <!--

          Disabling the automatic-test-on-build functionality as the MSBuild
          task seems to occasionally crash XBuild when it runs.  We should
          replace the MSBuild task with a task that executes the XUnit runner
          externally and reads in the XML file so that if the XUnit runner
          crashes it won't crash the Mono runtime used for XBuild.

          Change the Condition below to be "$(SkipTestsOnBuild) != 'True'" to
          reenable the test-on-build functionality.

        -->
        <Target Name="AfterBuild" Condition="1 == 0">
          <xunit Assembly="$(TargetPath)" />
        </Target>
      </xsl:if>
      
      {ADDITIONAL_TRANSFORMS}
      
      <xsl:if test="$project/NuGet">
        <UsingTask
          TaskName="Protobuild.Tasks.NugetPackTask">
          <xsl:attribute name="AssemblyFile">
            <xsl:value-of select="/Input/Generation/RootPath" />
            <xsl:text>Protobuild.exe</xsl:text>
          </xsl:attribute>
        </UsingTask>
        
        <Target Name="AfterBuild">
          <NugetPackTask
            ProjectPath="$(ProjectDir)"
            ContinueOnError="WarnAndContinue">
            <xsl:attribute name="NuspecFile">
              <xsl:value-of select="concat(
                $project/@Name,
                '.',
                /Input/Generation/Platform,
                '.nuspec')" />
            </xsl:attribute>
            <xsl:attribute name="RootPath">
              <xsl:value-of select="/Input/Generation/RootPath" />
            </xsl:attribute>
          </NugetPackTask>
        </Target>
      </xsl:if>
      
      <ItemGroup>
        <xsl:for-each select="$project/References/Reference">
          <xsl:variable name="include-name" select="./@Include" />
          <xsl:if test="
            count(/Input/Projects/Project[@Name=$include-name]) = 0">
            <xsl:if test="
              count(/Input/Projects/ExternalProject[@Name=$include-name]) > 0">

              <xsl:variable name="extern"
                select="/Input/Projects/ExternalProject[@Name=$include-name]" />
            
              <xsl:for-each select="$extern/Project">
                <ProjectReference>
                  <xsl:attribute name="Include">
                    <xsl:value-of
                      select="user:GetRelativePath(
                        concat(
                          $project/@Path,
                          '\',
                          $project/@Name,
                          '.',
                          /Input/Generation/Platform,
                          '.csproj'),
                        ./@Path)" />
                  </xsl:attribute>
                  <Project>{<xsl:value-of select="./@Guid" />}</Project>
                  <Name>
                    <xsl:value-of select="./@Name" />
                  </Name>
                </ProjectReference>
              </xsl:for-each>
              <xsl:for-each select="$extern/Platform
                                      [@Type=/Input/Generation/Platform]">
                <xsl:for-each select="./Project">
                  <ProjectReference>
                    <xsl:attribute name="Include">
                      <xsl:value-of
                        select="user:GetRelativePath(
                          concat(
                            $project/@Path,
                            '\',
                            $project/@Name,
                            '.',
                            /Input/Generation/Platform,
                            '.csproj'),
                          ./@Path)" />
                    </xsl:attribute>
                    <Project>{<xsl:value-of select="./@Guid" />}</Project>
                    <Name>
                      <xsl:value-of select="./@Name" />
                    </Name>
                  </ProjectReference>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </ItemGroup>
      
      <ItemGroup>
        <xsl:for-each select="$project/References/Reference">
          <xsl:variable name="include-path" select="./@Include" />
          <xsl:if test="
            count(/Input/Projects/Project[@Name=$include-path]) > 0">
            <xsl:if test="
              count(/Input/Projects/ExternalProject[@Name=$include-path]) = 0">

              <ProjectReference>
                <xsl:attribute name="Include">
                  <xsl:value-of
                    select="user:GetRelativePath(
                      concat(
                        $project/@Path,
                        '\',
                        $project/@Name,
                        '.',
                        /Input/Generation/Platform,
                        '.csproj'),
                      concat(
                        /Input/Projects/Project[@Name=$include-path]/@Path,
                        '\',
                        @Include,
                        '.',
                        /Input/Generation/Platform,
                        '.csproj'))" />
                </xsl:attribute>
                <Project>{<xsl:value-of 
select="/Input/Projects/Project[@Name=$include-path]/@Guid" />}</Project>
                <Name>
                  <xsl:value-of select="@Include" />
                  <xsl:text>.</xsl:text>
                  <xsl:value-of select="/Input/Generation/Platform" />
                </Name>
              </ProjectReference>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </ItemGroup>

    </Project>
    
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:element 
      name="{name()}" 
      namespace="http://schemas.microsoft.com/developer/msbuild/2003">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
