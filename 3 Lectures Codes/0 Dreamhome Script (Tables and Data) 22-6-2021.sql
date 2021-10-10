
/* 

DreamHome Script (Tables and Data)
Date: 22-6-2021

*/

USE MASTER
GO

CREATE DATABASE [Dreamhome]
GO

USE [Dreamhome]
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 24-Jun-21 6:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[branchNo] [varchar](4) NOT NULL,
	[street] [varchar](50) NULL,
	[city] [varchar](50) NULL,
	[postcode] [varchar](50) NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[branchNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Client]    Script Date: 24-Jun-21 6:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Client](
	[ClientNo] [varchar](4) NOT NULL,
	[fname] [varchar](50) NULL,
	[lname] [varchar](50) NULL,
	[telno] [varchar](50) NULL,
	[prefType] [varchar](50) NULL,
	[maxrent] [int] NULL,
 CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
(
	[ClientNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrivateOwner]    Script Date: 24-Jun-21 6:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrivateOwner](
	[ownerno] [varchar](4) NOT NULL,
	[fname] [varchar](50) NULL,
	[lname] [varchar](50) NULL,
	[address] [varchar](50) NULL,
	[telno] [varchar](50) NULL,
 CONSTRAINT [PK_PrivateOwner] PRIMARY KEY CLUSTERED 
(
	[ownerno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropertyForRent]    Script Date: 24-Jun-21 6:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyForRent](
	[PropertyNo] [varchar](4) NOT NULL,
	[street] [varchar](50) NULL,
	[city] [varchar](50) NULL,
	[postcode] [varchar](50) NULL,
	[type] [varchar](50) NULL,
	[rooms] [int] NULL,
	[rent] [int] NULL,
	[ownerNo] [varchar](4) NULL,
	[StaffNo] [varchar](4) NULL,
	[branchNo] [varchar](4) NULL,
 CONSTRAINT [PK_PropertyForRent] PRIMARY KEY CLUSTERED 
(
	[PropertyNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Registration]    Script Date: 24-Jun-21 6:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Registration](
	[clientno] [varchar](4) NOT NULL,
	[branchno] [varchar](4) NOT NULL,
	[staffno] [varchar](4) NULL,
	[datejoined] [date] NULL,
 CONSTRAINT [PK_Registration] PRIMARY KEY CLUSTERED 
(
	[clientno] ASC,
	[branchno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Staff]    Script Date: 24-Jun-21 6:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staff](
	[Staffno] [varchar](4) NOT NULL,
	[fname] [varchar](50) NULL,
	[lname] [varchar](50) NULL,
	[position] [varchar](50) NULL,
	[gender] [varchar](1) NULL,
	[dob] [date] NULL,
	[salary] [int] NULL,
	[branchno] [varchar](4) NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[Staffno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[viewing]    Script Date: 24-Jun-21 6:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[viewing](
	[Clientno] [varchar](4) NOT NULL,
	[propertyno] [varchar](4) NOT NULL,
	[viewdate] [date] NULL,
	[comment] [varchar](50) NULL,
 CONSTRAINT [PK_viewing] PRIMARY KEY CLUSTERED 
(
	[Clientno] ASC,
	[propertyno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Branch] ([branchNo], [street], [city], [postcode]) VALUES (N'B002', N'56 Clover Dr', N'London', N'NW10 6EU')
GO
INSERT [dbo].[Branch] ([branchNo], [street], [city], [postcode]) VALUES (N'B003', N'163 Main St', N'Glasgow', N'G11 9QX')
GO
INSERT [dbo].[Branch] ([branchNo], [street], [city], [postcode]) VALUES (N'B004', N'32 Manse Rd ', N'Bristol', N'BS99 1NZ')
GO
INSERT [dbo].[Branch] ([branchNo], [street], [city], [postcode]) VALUES (N'B005', N'22 Deer Rd', N'London', N'SW1 4EH')
GO
INSERT [dbo].[Branch] ([branchNo], [street], [city], [postcode]) VALUES (N'B007', N'16 Argy11 St', N'Aberdeen', N'AB2 3SU')
GO
INSERT [dbo].[Client] ([ClientNo], [fname], [lname], [telno], [prefType], [maxrent]) VALUES (N'CR56', N'Aline', N'Stewart', N'0141-848-1825', N'Flat', 350)
GO
INSERT [dbo].[Client] ([ClientNo], [fname], [lname], [telno], [prefType], [maxrent]) VALUES (N'CR62', N'Mary', N'Tregear', N'01224-19670', N'Flat', 600)
GO
INSERT [dbo].[Client] ([ClientNo], [fname], [lname], [telno], [prefType], [maxrent]) VALUES (N'CR74', N'Mike', N'Ritchie', N'01475-392178', N'House', 750)
GO
INSERT [dbo].[Client] ([ClientNo], [fname], [lname], [telno], [prefType], [maxrent]) VALUES (N'CR76', N'John', N'Kay', N'0207-774-5632', N'Flat', 425)
GO
INSERT [dbo].[PrivateOwner] ([ownerno], [fname], [lname], [address], [telno]) VALUES (N'CO40', N'Tina', N'Murphy', N'63 Well St, Glasgow G42', N'0141-943-1728')
GO
INSERT [dbo].[PrivateOwner] ([ownerno], [fname], [lname], [address], [telno]) VALUES (N'CO46', N'Joe', N'Keogh', N'2 Fregus Dr, Aberdeen AB2 75X', N'01224-861212')
GO
INSERT [dbo].[PrivateOwner] ([ownerno], [fname], [lname], [address], [telno]) VALUES (N'CO87', N'Carol', N'Farrel', N'6 Achary St, Glasgow G32 9DX', N'0141-357-7419')
GO
INSERT [dbo].[PrivateOwner] ([ownerno], [fname], [lname], [address], [telno]) VALUES (N'CO93', N'Tony', N'Shaw', N'12 Park Pl, Glasgow G4 0QR', N'0141-225-7025')
GO
INSERT [dbo].[PropertyForRent] ([PropertyNo], [street], [city], [postcode], [type], [rooms], [rent], [ownerNo], [StaffNo], [branchNo]) VALUES (N'PA14', N'16 Holhead', N'Aberdeen', N'AB7 5SU', N'House', 6, 650, N'CO46', N'SA9', N'B007')
GO
INSERT [dbo].[PropertyForRent] ([PropertyNo], [street], [city], [postcode], [type], [rooms], [rent], [ownerNo], [StaffNo], [branchNo]) VALUES (N'PG16', N'5 Novar Dr', N'Glasgow', N'G12 9AX', N'Flat', 4, 450, N'CO93', N'SG14', N'B003')
GO
INSERT [dbo].[PropertyForRent] ([PropertyNo], [street], [city], [postcode], [type], [rooms], [rent], [ownerNo], [StaffNo], [branchNo]) VALUES (N'PG21', N'18 Dale Rd', N'Glasgow', N'G12', N'House', 5, 200, N'CO87', N'SG37', N'B003')
GO
INSERT [dbo].[PropertyForRent] ([PropertyNo], [street], [city], [postcode], [type], [rooms], [rent], [ownerNo], [StaffNo], [branchNo]) VALUES (N'PG36', N'2 Manor Rd', N'Glasgow', N'G32 4QX', N'Flat', 3, 375, N'CO93', N'SG37', N'B003')
GO
INSERT [dbo].[PropertyForRent] ([PropertyNo], [street], [city], [postcode], [type], [rooms], [rent], [ownerNo], [StaffNo], [branchNo]) VALUES (N'PG4', N'6 Lawrence St', N'Glasgow', N'G11 9QX', N'Flat', 3, 350, N'CO40', NULL, N'B003')
GO
INSERT [dbo].[PropertyForRent] ([PropertyNo], [street], [city], [postcode], [type], [rooms], [rent], [ownerNo], [StaffNo], [branchNo]) VALUES (N'PL94', N'6 Argyll St', N'London', N'NW2', N'Flat', 4, 400, N'CO87', N'SL41', N'B005')
GO
INSERT [dbo].[Registration] ([clientno], [branchno], [staffno], [datejoined]) VALUES (N'CR56', N'B003', N'SG37', CAST(N'2003-04-11' AS Date))
GO
INSERT [dbo].[Registration] ([clientno], [branchno], [staffno], [datejoined]) VALUES (N'CR62', N'B007', N'SA9', CAST(N'2003-03-07' AS Date))
GO
INSERT [dbo].[Registration] ([clientno], [branchno], [staffno], [datejoined]) VALUES (N'CR74', N'B003', N'SG37', CAST(N'2002-11-16' AS Date))
GO
INSERT [dbo].[Registration] ([clientno], [branchno], [staffno], [datejoined]) VALUES (N'CR76', N'B005', N'SL41', CAST(N'2004-01-02' AS Date))
GO
INSERT [dbo].[Staff] ([Staffno], [fname], [lname], [position], [gender], [dob], [salary], [branchno]) VALUES (N'SA9', N'Mary', N'Howe', N'Assistant', N'F', CAST(N'1970-02-19' AS Date), 9270, N'B007')
GO
INSERT [dbo].[Staff] ([Staffno], [fname], [lname], [position], [gender], [dob], [salary], [branchno]) VALUES (N'SG14', N'David', N'Ford', N'Supervisor', N'M', CAST(N'1958-03-24' AS Date), 18000, N'B003')
GO
INSERT [dbo].[Staff] ([Staffno], [fname], [lname], [position], [gender], [dob], [salary], [branchno]) VALUES (N'SG37', N'Ann', N'Beech', N'Assistant', N'F', CAST(N'1960-11-10' AS Date), 12000, N'B003')
GO
INSERT [dbo].[Staff] ([Staffno], [fname], [lname], [position], [gender], [dob], [salary], [branchno]) VALUES (N'SG5', N'Susan', N'Brand', N'Manager', N'F', CAST(N'1940-06-03' AS Date), 24000, N'B003')
GO
INSERT [dbo].[Staff] ([Staffno], [fname], [lname], [position], [gender], [dob], [salary], [branchno]) VALUES (N'SL21', N'John', N'White', N'Manager', N'M', CAST(N'1945-10-01' AS Date), 30000, N'B005')
GO
INSERT [dbo].[Staff] ([Staffno], [fname], [lname], [position], [gender], [dob], [salary], [branchno]) VALUES (N'SL41', N'Julie', N'Lee', N'Assistance', N'F', CAST(N'1965-06-13' AS Date), 9000, N'B005')
GO
INSERT [dbo].[viewing] ([Clientno], [propertyno], [viewdate], [comment]) VALUES (N'CR56', N'PA14', CAST(N'2004-05-24' AS Date), N'too small')
GO
INSERT [dbo].[viewing] ([Clientno], [propertyno], [viewdate], [comment]) VALUES (N'CR56', N'PG36', CAST(N'2004-05-14' AS Date), NULL)
GO
INSERT [dbo].[viewing] ([Clientno], [propertyno], [viewdate], [comment]) VALUES (N'CR56', N'PG4', CAST(N'2004-05-26' AS Date), NULL)
GO
INSERT [dbo].[viewing] ([Clientno], [propertyno], [viewdate], [comment]) VALUES (N'CR62', N'PA14', CAST(N'2004-05-14' AS Date), N'no dining room')
GO
INSERT [dbo].[viewing] ([Clientno], [propertyno], [viewdate], [comment]) VALUES (N'CR76', N'PG4', CAST(N'2004-04-20' AS Date), N'too remote')
GO
ALTER TABLE [dbo].[PropertyForRent]  WITH CHECK ADD  CONSTRAINT [FK_PropertyForRent_Branch] FOREIGN KEY([branchNo])
REFERENCES [dbo].[Branch] ([branchNo])
GO
ALTER TABLE [dbo].[PropertyForRent] CHECK CONSTRAINT [FK_PropertyForRent_Branch]
GO
ALTER TABLE [dbo].[PropertyForRent]  WITH CHECK ADD  CONSTRAINT [FK_PropertyForRent_Staff] FOREIGN KEY([StaffNo])
REFERENCES [dbo].[Staff] ([Staffno])
GO
ALTER TABLE [dbo].[PropertyForRent] CHECK CONSTRAINT [FK_PropertyForRent_Staff]
GO
ALTER TABLE [dbo].[Registration]  WITH CHECK ADD  CONSTRAINT [FK_Registration_Branch] FOREIGN KEY([branchno])
REFERENCES [dbo].[Branch] ([branchNo])
GO
ALTER TABLE [dbo].[Registration] CHECK CONSTRAINT [FK_Registration_Branch]
GO
ALTER TABLE [dbo].[Registration]  WITH CHECK ADD  CONSTRAINT [FK_Registration_Client] FOREIGN KEY([clientno])
REFERENCES [dbo].[Client] ([ClientNo])
GO
ALTER TABLE [dbo].[Registration] CHECK CONSTRAINT [FK_Registration_Client]
GO
ALTER TABLE [dbo].[Registration]  WITH CHECK ADD  CONSTRAINT [FK_Registration_Staff] FOREIGN KEY([staffno])
REFERENCES [dbo].[Staff] ([Staffno])
GO
ALTER TABLE [dbo].[Registration] CHECK CONSTRAINT [FK_Registration_Staff]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Branch] FOREIGN KEY([branchno])
REFERENCES [dbo].[Branch] ([branchNo])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_Branch]
GO
ALTER TABLE [dbo].[viewing]  WITH CHECK ADD  CONSTRAINT [FK_viewing_Client] FOREIGN KEY([Clientno])
REFERENCES [dbo].[Client] ([ClientNo])
GO
ALTER TABLE [dbo].[viewing] CHECK CONSTRAINT [FK_viewing_Client]
GO
ALTER TABLE [dbo].[viewing]  WITH CHECK ADD  CONSTRAINT [FK_viewing_PropertyForRent] FOREIGN KEY([propertyno])
REFERENCES [dbo].[PropertyForRent] ([PropertyNo])
GO
ALTER TABLE [dbo].[viewing] CHECK CONSTRAINT [FK_viewing_PropertyForRent]
GO
