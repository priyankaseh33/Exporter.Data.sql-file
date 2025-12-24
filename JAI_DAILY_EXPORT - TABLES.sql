USE [JAI_DAILY_EXPORT]
GO
/****** Object:  Table [dbo].[Export_LMSJob]    Script Date: 12/24/2025 12:35:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_LMSJob](
	[JobId] [int] IDENTITY(1,1) NOT NULL,
	[JobCode] [nvarchar](100) NOT NULL,
	[JobName] [nvarchar](200) NOT NULL,
	[StoredProcName] [sysname] NOT NULL,
	[FileNameTemplate] [nvarchar](400) NOT NULL,
	[SheetName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[ExecuteOrder] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[OutputSubfolder] [nvarchar](255) NULL,
	[OutputRootKey] [nvarchar](200) NULL,
	[SourceTableName] [nvarchar](255) NULL,
	[PrimaryKeyColumnName] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export_LMSJobParam]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_LMSJobParam](
	[JobParamId] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[ParamName] [nvarchar](128) NOT NULL,
	[ParamType] [nvarchar](50) NOT NULL,
	[ParamValue] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export_LMSJobRun]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_LMSJobRun](
	[RunId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[StartedAt] [datetime2](7) NOT NULL,
	[EndedAt] [datetime2](7) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[RowsExported] [int] NULL,
	[OutputFilePath] [nvarchar](1000) NULL,
	[Message] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export_LMSJobRunError]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_LMSJobRunError](
	[RunErrorId] [bigint] IDENTITY(1,1) NOT NULL,
	[RunId] [bigint] NOT NULL,
	[ErrorAt] [datetime2](7) NOT NULL,
	[Stage] [nvarchar](100) NOT NULL,
	[ErrorMessage] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export_LMSSchedule]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_LMSSchedule](
	[ScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[RunTime] [time](0) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[LastRunDate] [date] NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
	[UpdatedAt] [datetime2](0) NULL,
PRIMARY KEY CLUSTERED 
(
	[ScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export_LMSSetting]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_LMSSetting](
	[SettingKey] [nvarchar](200) NOT NULL,
	[SettingValue] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export_PrintJob]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_PrintJob](
	[JobId] [int] IDENTITY(1,1) NOT NULL,
	[JobCode] [nvarchar](100) NOT NULL,
	[JobName] [nvarchar](200) NOT NULL,
	[StoredProcName] [sysname] NOT NULL,
	[FileNameTemplate] [nvarchar](400) NOT NULL,
	[SheetName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[ExecuteOrder] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[OutputSubfolder] [nvarchar](255) NULL,
	[OutputRootKey] [nvarchar](200) NULL,
	[SourceTableName] [nvarchar](255) NULL,
	[PrimaryKeyColumnName] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export_PrintJobParam]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_PrintJobParam](
	[JobParamId] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[ParamName] [nvarchar](128) NOT NULL,
	[ParamType] [nvarchar](50) NOT NULL,
	[ParamValue] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export_PrintJobRun]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_PrintJobRun](
	[RunId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[StartedAt] [datetime2](7) NOT NULL,
	[EndedAt] [datetime2](7) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[RowsExported] [int] NULL,
	[OutputFilePath] [nvarchar](1000) NULL,
	[Message] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export_PrintJobRunError]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_PrintJobRunError](
	[RunErrorId] [bigint] IDENTITY(1,1) NOT NULL,
	[RunId] [bigint] NOT NULL,
	[ErrorAt] [datetime2](7) NOT NULL,
	[Stage] [nvarchar](100) NOT NULL,
	[ErrorMessage] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export_PrintSetting]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export_PrintSetting](
	[SettingKey] [nvarchar](200) NOT NULL,
	[SettingValue] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExportJob]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExportJob](
	[JobId] [int] IDENTITY(1,1) NOT NULL,
	[JobCode] [nvarchar](100) NOT NULL,
	[JobName] [nvarchar](200) NOT NULL,
	[StoredProcName] [sysname] NOT NULL,
	[FileNameTemplate] [nvarchar](400) NOT NULL,
	[SheetName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[ExecuteOrder] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[OutputSubfolder] [nvarchar](255) NULL,
	[OutputRootKey] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[JobId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[JobCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExportJobParam]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExportJobParam](
	[JobParamId] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[ParamName] [nvarchar](128) NOT NULL,
	[ParamType] [nvarchar](50) NOT NULL,
	[ParamValue] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[JobParamId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExportJobRun]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExportJobRun](
	[RunId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[StartedAt] [datetime2](7) NOT NULL,
	[EndedAt] [datetime2](7) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[RowsExported] [int] NULL,
	[OutputFilePath] [nvarchar](1000) NULL,
	[Message] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[RunId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExportJobRunError]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExportJobRunError](
	[RunErrorId] [bigint] IDENTITY(1,1) NOT NULL,
	[RunId] [bigint] NOT NULL,
	[ErrorAt] [datetime2](7) NOT NULL,
	[Stage] [nvarchar](100) NOT NULL,
	[ErrorMessage] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RunErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExportSetting]    Script Date: 12/24/2025 12:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExportSetting](
	[SettingKey] [nvarchar](200) NOT NULL,
	[SettingValue] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SettingKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Export_LMSSchedule] ADD  CONSTRAINT [DF_Export_LMSSchedule_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Export_LMSSchedule] ADD  CONSTRAINT [DF_Export_LMSSchedule_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ExportJob] ADD  DEFAULT (N'Data') FOR [SheetName]
GO
ALTER TABLE [dbo].[ExportJob] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ExportJob] ADD  DEFAULT ((1)) FOR [ExecuteOrder]
GO
ALTER TABLE [dbo].[ExportJob] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ExportJob] ADD  DEFAULT (sysutcdatetime()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[ExportJobParam] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ExportJobRun] ADD  DEFAULT (sysutcdatetime()) FOR [StartedAt]
GO
ALTER TABLE [dbo].[ExportJobRunError] ADD  DEFAULT (sysutcdatetime()) FOR [ErrorAt]
GO
ALTER TABLE [dbo].[ExportJobRunError]  WITH CHECK ADD FOREIGN KEY([RunId])
REFERENCES [dbo].[ExportJobRun] ([RunId])
ON DELETE CASCADE
GO
