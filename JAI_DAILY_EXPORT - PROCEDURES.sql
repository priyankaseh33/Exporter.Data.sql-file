USE [JAI_DAILY_EXPORT]
GO
/****** Object:  StoredProcedure [dbo].[SP_dailyexport_LMS]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE or ALTER PROCEDURE [dbo].[SP_dailyexport_LMS]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	--where contract_status_code in ('REPO','AUCT')
	where contract_status_code in ('AAAAAA')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_dailyexport_LMS_AUCT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_dailyexport_LMS_AUCT]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('AUCT')
	--where contract_status_code in ('REPO','AUCT')
	--where contract_status_code in ('AAAAAA')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_dailyexport_LMS_REPO]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_dailyexport_LMS_REPO]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('REPO')
	--where contract_status_code in ('REPO','AUCT')
	--where contract_status_code in ('AAAAAA')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_18]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_18]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        guarantor_name_display AS Field3,
        contract_number AS Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field5,
        amount_original_finance_total AS Field6,        
        car_brand_name AS Field7,
        car_model_name AS Field8,
        license_number AS Field9,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field10,
        FORMAT(auction_date, 'dd MMMM yyyy', 'th-TH') AS Field11,
        auction_company_name AS Field12,
        amount_sold_price_total AS Field13,
        amount_account_closing_balance AS Field14,
        amount_outstanding AS Field15,
		--NULL AS Field16,
		--NULL AS Field17,
        amount_outstanding AS Field18,
        amount_outstanding_total AS Field19,
        text_outstanding_total AS Field20,            
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 3) AS Field21,
        receiver_name_display AS Field22,
        receiver_mailing_address AS Field23
        ,letter_id
    FROM
		[repossess_jai].[dbo].[jai_vw_letter_foreclosure_result_transactions]
    WHERE
        letter_type_code = 'CRL1';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_18_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_18_1]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        contract_number AS Field3,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field4,
        amount_original_finance_total AS Field5,
        car_brand_name AS Field6,
        car_model_name AS Field7,
        license_number AS Field8,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field9,
		FORMAT(auction_date, 'dd MMMM yyyy', 'th-TH') AS Field10,
        auction_company_name AS Field11,

        -- Financial calculation fields
        amount_sold_price_total AS Field12,
        amount_account_closing_balance AS Field13,
        amount_outstanding AS Field14,
        NULL AS Field15,
        amount_outstanding AS Field16,
        amount_outstanding_total AS Field17,
        text_outstanding_total AS Field18,        
        (SELECT [phone]   FROM [repossess_jai].[dbo].[jai_vw_staff_assignment]WHERE assginment_id = 3) AS Field19,
        receiver_name_display AS Field20,
        receiver_mailing_address AS Field21,
        letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_letter_foreclosure_result_transactions]
    WHERE
        letter_type_code = 'CRL1';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_18g]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_18g]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
    letter_issued_date                    AS [Field1],
    borrower_name_display                 AS [Field2],
    guarantor_name_display                AS [Field3],
    contract_number                       AS [Field4],
    contract_issued_date                  AS [Field5],
    amount_original_finance_total         AS [Field6],
    car_brand_name                        AS [Field7],
    car_model_name                        AS [Field8],
    license_number                        AS [Field9],
    expropriated_date                     AS [Field10],
    expropriated_date                     AS [Field11],
    auction_date                          AS [Field12],
    auction_company_name                  AS [Field13],
    amount_sold_price_total               AS [Field14],
    amount_account_closing_balance        AS [Field15],
    ''                                    AS [Field16],  -- blank
    ''                                    AS [Field17],  -- blank
    amount_outstanding                    AS [Field18],
    amount_outstanding_total              AS [Field19],
    text_outstanding_total                AS [Field20],
    (
        SELECT TOP (1) phone
        FROM [repossess_jai].[dbo].[jai_vw_staff_assignment]
        WHERE assginment_id = 3
    )                                     AS [Field21],
    receiver_name_display                 AS [Field22],
    receiver_mailing_address              AS [Field23]
    ,letter_id
FROM [repossess_jai].[dbo].[jai_vw_letter_foreclosure_result_transactions]
WHERE letter_type_code = 'CRL1'
  AND isBorrower = 'N'
  AND isGuarantor = 'Y';

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_19_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_19_1]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        guarantor_name_display AS Field3,
        contract_number AS Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field5,
        car_brand_name AS Field6,
        car_model_name AS Field7,
        license_number AS Field8,
        amount_original_finance_total AS Field9,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field10,
		FORMAT(auction_date, 'dd MMMM yyyy', 'th-TH') AS Field11,
        auction_company_name AS Field12,
        
        -- Financial calculation fields
        amount_sold_price_total AS Field13,
        amount_account_closing_balance AS Field14,
        amount_outstanding AS Field15,
        amount_outstanding AS Field16,
        amount_outstanding_total AS Field17,
        text_outstanding_total AS Field18,
        
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 3) AS Field19,
        receiver_name_display AS Field20,
        receiver_mailing_address AS Field21,
        letter_id
    FROM
         [repossess_jai].[dbo].[jai_vw_letter_foreclosure_result_transactions]
    WHERE
        letter_type_code = 'C2C1';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_19_1_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_19_1_1]
AS
BEGIN
    SET NOCOUNT ON;

	
    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        contract_number AS Field3,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field4,
        car_brand_name AS Field5,
        car_model_name AS Field6,
        license_number + ' ' + vehicle_registration_province AS Field7,
        amount_original_finance_total AS Field8,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field9,
		FORMAT(auction_date, 'dd MMMM yyyy', 'th-TH') AS Field10,
        auction_company_name AS Field11,
        amount_sold_price_total AS Field12,
        amount_account_closing_balance AS Field13,
        amount_outstanding AS Field14,
        amount_outstanding AS Field15,
        amount_outstanding_total AS Field16,
        text_outstanding_total AS Field17,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 3) AS Field18,
        receiver_name_display AS Field19,
        receiver_mailing_address AS Field20
        ,letter_id
    FROM
         [repossess_jai].[dbo].[jai_vw_letter_foreclosure_result_transactions]
    WHERE
        letter_type_code = 'C2C1';
		
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_19_1g]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_19_1g]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
    letter_issued_date                    AS [Field1],
    borrower_name_display                 AS [Field2],
    guarantor_name_display                AS [Field3],
    contract_number                       AS [Field4],
    contract_issued_date                  AS [Field5],
    car_brand_name                        AS [Field6],
    car_model_name                        AS [Field7],
    license_number                        AS [Field8],
    amount_original_finance_total         AS [Field9],
    expropriated_date                     AS [Field10],
    auction_date                          AS [Field11],
    auction_company_name                  AS [Field12],
    amount_sold_price_total               AS [Field13],
    amount_account_closing_balance        AS [Field14],
    amount_outstanding                    AS [Field15],
    amount_outstanding                    AS [Field16],
    amount_outstanding_total              AS [Field17],
    text_outstanding_total                AS [Field18],
    (
        SELECT TOP (1) phone
        FROM [repossess_jai].[dbo].[jai_vw_staff_assignment]
        WHERE assginment_id = 3
    )                                     AS [Field19],
    receiver_name_display                 AS [Field20],
    receiver_mailing_address              AS [Field21]
    ,letter_id
FROM [repossess_jai].[dbo].[jai_vw_letter_foreclosure_result_transactions]
WHERE letter_type_code = 'C2C1'
  AND isBorrower = 'N'
  AND isGuarantor = 'Y';



END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_19_3]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_19_3]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        contract_number AS Field3,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field4,
        car_brand_name AS Field5,
        car_model_name AS Field6,
        --license_number + ' ' + vehicle_registration_province AS Field7,
		license_number AS Field7,
        amount_original_finance_total AS Field8,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field9,
        auction_date AS Field10,
        auction_company_name AS Field11,
        amount_sold_price_total AS Field12,
        amount_account_closing_balance AS Field13,
        amount_outstanding AS Field14,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 3) AS Field15,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 3) AS Field16,
        receiver_name_display AS Field17,
        receiver_mailing_address AS Field18
        ,letter_id
    FROM
         [repossess_jai].[dbo].[jai_vw_letter_foreclosure_result_transactions]
    WHERE
        letter_type_code = 'C2C2';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_19_3_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_19_3_1]
AS
BEGIN
    SET NOCOUNT ON;


    SELECT
    letter_issued_date                    AS Field1,
    borrower_name_display                 AS Field2,
    guarantor_name_display                AS Field3,
    contract_number                       AS Field4,
    contract_issued_date                  AS Field5,
    car_brand_name                        AS Field6,
    car_model_name                        AS Field7,
    license_number                        AS Field8,
    amount_original_finance_total         AS Field9,
    expropriated_date                     AS Field10,
    auction_date                          AS Field11,
    auction_company_name                  AS Field12,
    amount_sold_price_total               AS Field13,
    amount_account_closing_balance        AS Field14,
    amount_outstanding                    AS Field15,
    (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 3) AS Field16,
    (SELECT phone     FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 3) AS Field17,
    receiver_name_display                 AS Field18,
    receiver_mailing_address              AS Field19
FROM [repossess_jai].[dbo].[jai_vw_letter_foreclosure_result_transactions]
WHERE letter_type_code = 'C2C2'
  AND isBorrower = 'N'
  AND isGuarantor = 'Y';




END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_19_4]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE  [dbo].[SP_Export_Print_19_4]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
    letter_issued_date                AS Field1,
    borrower_name_display             AS Field2,
    contract_number                   AS Field3,
    contract_issued_date              AS Field4,
    amount_original_finance_total     AS Field5,
    car_brand_name                    AS Field6,
    car_model_name                    AS Field7,
    license_number                    AS Field8,
    expropriated_date                 AS Field9,
    auction_date                      AS Field10,
    auction_company_name              AS Field11,
    amount_sold_price_total           AS Field12,
    amount_account_closing_balance    AS Field13,
    amount_outstanding_total          AS Field14,
    text_outstanding_total            AS Field15,
    (SELECT full_name
     FROM [repossess_jai].[dbo].[jai_vw_staff_assignment]
     WHERE assginment_id = 3)        AS Field16,
    (SELECT phone
     FROM [repossess_jai].[dbo].[jai_vw_staff_assignment]
     WHERE assginment_id = 3)        AS Field17,
    receiver_name_display             AS Field18,
    receiver_mailing_address          AS Field19
    ,letter_id
FROM [repossess_jai].[dbo].[jai_vw_letter_foreclosure_result_transactions]
WHERE 
letter_type_code = 'CRL2'
  AND isBorrower      = 'Y'
  AND isGuarantor     = 'N';

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_19_4_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE  [dbo].[SP_Export_Print_19_4_1]
AS
BEGIN
    SET NOCOUNT ON;

   SELECT
    letter_issued_date                AS Field1,
    borrower_name_display             AS Field2,
    guarantor_name_display            AS Field3,
    contract_number                   AS Field4,
    contract_issued_date              AS Field5,
    amount_original_finance_total     AS Field6,
    car_brand_name                    AS Field7,
    car_model_name                    AS Field8,
    license_number                    AS Field9,
    expropriated_date                 AS Field10,
    auction_date                      AS Field11,
    auction_company_name              AS Field12,
    amount_sold_price_total           AS Field13,
    amount_account_closing_balance    AS Field14,
    amount_outstanding_total          AS Field15,
    text_outstanding_total            AS Field16,
    (SELECT full_name
     FROM [repossess_jai].[dbo].[jai_vw_staff_assignment]
     WHERE assginment_id = 3)        AS Field17,
    (SELECT phone
     FROM [repossess_jai].[dbo].[jai_vw_staff_assignment]
     WHERE assginment_id = 3)        AS Field18,
    receiver_name_display             AS Field19,
    receiver_mailing_address          AS Field20
FROM [repossess_jai].[dbo].[jai_vw_letter_foreclosure_result_transactions]
WHERE letter_type_code = 'CRL2'
  AND isBorrower      = 'N'
  AND isGuarantor     = 'Y';




END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_1]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') as Field1,
        borrower_name_display as Field2,
        guarantor_name_display as Field3,
        contract_number as Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') as Field5,
        car_brand_name as Field6,
        car_model_name as Field7,
        license_number+' ' +vehicle_registration_province as Field8,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') as Field9,
        auction_company_name as Field10,
        auction_company_address as Field11,
        amount_appraised_value as Field12,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') as Field13,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') as Field14,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') as Field15,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') as Field16,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') as Field17,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') as Field18,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') as Field19,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') as Field20,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') as Field21,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') as Field22,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') as Field23,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') as Field24,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) as Field25,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) as Field26,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) as Field27,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) as Field28,
        receiver_name_display as Field29,
        receiver_mailing_address as Field30,
        letter_id
    FROM 
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]

    WHERE    
        letter_issued_times = 1
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        AND letter_type_code = 'C2C61GY';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_1_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_1_1]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        contract_number AS Field3,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field4,
        car_brand_name AS Field5,
        car_model_name AS Field6,
        license_number + ' ' + vehicle_registration_province AS Field7,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field8,
        auction_company_name AS Field9,
        auction_company_address AS Field10,
        amount_appraised_value AS Field11,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field12,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field22,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field23,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field24,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field25,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field26,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field27,
        receiver_name_display AS Field28,
        receiver_mailing_address AS Field29,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE  
        letter_issued_times = 1
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        AND letter_type_code = 'C2C61GN';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_1G]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_1G]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') as Field1,
        borrower_name_display as Field2,
        guarantor_name_display as Field3,
        contract_number as Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') as Field5,
        car_brand_name as Field6,
        car_model_name as Field7,
        license_number+' ' +vehicle_registration_province as Field8,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') as Field9,
        auction_company_name as Field10,
        auction_company_address as Field11,
        amount_appraised_value as Field12,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') as Field13,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') as Field14,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') as Field15,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') as Field16,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') as Field17,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') as Field18,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') as Field19,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') as Field20,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') as Field21,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') as Field22,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') as Field23,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') as Field24,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) as Field25,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) as Field26,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) as Field27,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) as Field28,
        receiver_name_display as Field29,
        receiver_mailing_address as Field30,
        letter_id
    FROM 
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]

    WHERE    
        letter_issued_times = 1
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        AND letter_type_code = 'C2C61GY';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_2]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_2]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        guarantor_name_display AS Field3,
        contract_number AS Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field5,
        car_brand_name AS Field6,
        car_model_name AS Field7,
        license_number + ' ' + vehicle_registration_province AS Field8,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field9,
        auction_company_name AS Field10,
        auction_company_address AS Field11,
        amount_appraised_value AS Field12,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field22,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field23,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field24,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field25,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field26,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field27,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field28,
        receiver_name_display AS Field29,
        receiver_mailing_address AS Field30,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE  
     letter_type_code = 'C2C65GY'
        AND letter_issued_times = 1
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        ;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_2_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_2_1]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        contract_number AS Field3,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field4,
        car_brand_name AS Field5,
        car_model_name AS Field6,
        license_number + ' ' + vehicle_registration_province AS Field7,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field8,
        auction_company_name AS Field9,
        auction_company_address AS Field10,
        amount_appraised_value AS Field11,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field12,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field22,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field23,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field24,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field25,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field26,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field27,
        receiver_name_display AS Field28,
        receiver_mailing_address AS Field29,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE
        letter_issued_times = 1
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        AND letter_type_code = 'C2C65GN';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_2G]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_2G]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
    FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        guarantor_name_display AS Field3,
        contract_number AS Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field5,
        car_brand_name AS Field6,
        car_model_name AS Field7,
        license_number + ' ' + vehicle_registration_province AS Field8,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field9,
        auction_company_name AS Field10,
        auction_company_address AS Field11,
        amount_appraised_value AS Field12,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field22,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field23,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field24,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field25,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field26,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field27,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field28,
        receiver_name_display AS Field29,
        receiver_mailing_address AS Field30,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE  
     letter_type_code = 'C2C65GY'
        AND letter_issued_times = 1
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        ;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_3]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_3]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        guarantor_name_display AS Field3,
        contract_number AS Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field5,
        amount_finance AS Field6,
        car_brand_name AS Field7,
        car_model_name AS Field8,
        license_number + ' ' + vehicle_registration_province AS Field9,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field10,
        auction_company_name AS Field11,
        auction_company_address AS Field12,
        amount_appraised_value AS Field13,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field22,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field23,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field24,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field25,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field26,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field27,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field28,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field29,
        receiver_name_display AS Field30,
        receiver_mailing_address AS Field31,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE
        letter_issued_times = 1
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        AND letter_type_code = 'CRLGN';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_3_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_3_1]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        contract_number AS Field3,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field4,
        amount_finance AS Field5,
        car_brand_name AS Field6,
        car_model_name AS Field7,
        license_number AS Field8,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field9,
        auction_company_name AS Field10,
        auction_company_address AS Field11,
        amount_appraised_value AS Field12,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field22,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field23,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field24,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field25,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field26,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field27,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field28,
        receiver_name_display AS Field29,
        receiver_mailing_address AS Field30,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE
    letter_type_code = 'CRLGN'
        
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        AND letter_issued_times = 1
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_3G]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_3G]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        guarantor_name_display AS Field3,
        contract_number AS Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field5,
        amount_finance AS Field6,
        car_brand_name AS Field7,
        car_model_name AS Field8,
        license_number + ' ' + vehicle_registration_province AS Field9,
        FORMAT(expropriated_date, 'dd MMMM yyyy', 'th-TH') AS Field10,
        auction_company_name AS Field11,
        auction_company_address AS Field12,
        amount_appraised_value AS Field13,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field22,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field23,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field24,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field25,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field26,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field27,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field28,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field29,
        receiver_name_display AS Field30,
        receiver_mailing_address AS Field31,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE
        letter_issued_times = 1
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
       -- AND letter_type_code = 'C2CGY';
       AND letter_type_code = 'CRLGY';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_4]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_4]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        guarantor_name_display AS Field3,
        contract_number AS Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field5,
        car_brand_name AS Field6,
        car_model_name AS Field7,
        license_number + ' ' + vehicle_registration_province AS Field8,
        auction_company_name AS Field9,
        auction_company_address AS Field10,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field11,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field12,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field22,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field23,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field24,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field25,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field26,
        receiver_name_display AS Field27,
        receiver_mailing_address AS Field28,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE
         letter_issued_times = 2
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
      AND letter_type_code IN ('C2C61GN', 'C2C65GN');
    
        
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_4_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_4_1]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        contract_number AS Field3,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field4,
        car_brand_name AS Field5,
        car_model_name AS Field6,
        license_number AS Field7,
        auction_company_name AS Field8,
        auction_company_address AS Field9,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field10,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field11,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field12,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field21,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field22,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field23,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field24,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field25,
        receiver_name_display AS Field26,
        receiver_mailing_address AS Field27,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE
         letter_issued_times = 2
         AND status_code = 2220 /* don't forget change back to status_code 2210 */
         AND letter_type_code IN ('C2C61GN', 'C2C65GN');
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_4_2]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_4_2]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        guarantor_name_display AS Field3,
        contract_number AS Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field5,
        NULL AS Field6, -- Placeholder for Field6
        car_brand_name AS Field7,
        car_model_name AS Field8,
        license_number + ' ' + vehicle_registration_province AS Field9,
        auction_company_name AS Field10,
        auction_company_address AS Field11,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field12,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field22,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field23,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field24,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field25,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field26,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field27,
        receiver_name_display AS Field28,
        receiver_mailing_address AS Field29,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE
        letter_issued_times = 2
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        AND 
        letter_type_code = 'CRLGN';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_4_2G]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_4_2G]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        guarantor_name_display AS Field3,
        contract_number AS Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field5,
        NULL AS Field6, -- Placeholder for Field6
        car_brand_name AS Field7,
        car_model_name AS Field8,
        license_number + ' ' + vehicle_registration_province AS Field9,
        auction_company_name AS Field10,
        auction_company_address AS Field11,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field12,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field22,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field23,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field24,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field25,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field26,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field27,
        receiver_name_display AS Field28,
        receiver_mailing_address AS Field29,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE
        letter_issued_times = 2
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        AND 
        letter_type_code = 'CRLGN';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_4_3]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_4_3]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        contract_number AS Field3,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field4,
        NULL AS Field5, -- Placeholder for Field5
        car_brand_name AS Field6,
        car_model_name AS Field7,
        license_number + ' ' + vehicle_registration_province AS Field8,
        auction_company_name AS Field9,
        auction_company_address AS Field10,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field11,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field12,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field22,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field23,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field24,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field25,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field26,
        receiver_name_display AS Field27,
        receiver_mailing_address AS Field28,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE
        letter_issued_times = 2
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        AND letter_type_code = 'CRLGN';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_4G]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_4G]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FORMAT(letter_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field1,
        borrower_name_display AS Field2,
        guarantor_name_display AS Field3,
        contract_number AS Field4,
        FORMAT(contract_issued_date, 'dd MMMM yyyy', 'th-TH') AS Field5,
        car_brand_name AS Field6,
        car_model_name AS Field7,
        license_number + ' ' + vehicle_registration_province AS Field8,
        auction_company_name AS Field9,
        auction_company_address AS Field10,
        FORMAT(auctionDate01, 'dd MMMM yyyy', 'th-TH') AS Field11,
        FORMAT(auctionDate02, 'dd MMMM yyyy', 'th-TH') AS Field12,
        FORMAT(auctionDate03, 'dd MMMM yyyy', 'th-TH') AS Field13,
        FORMAT(auctionDate04, 'dd MMMM yyyy', 'th-TH') AS Field14,
        FORMAT(auctionDate05, 'dd MMMM yyyy', 'th-TH') AS Field15,
        FORMAT(auctionDate06, 'dd MMMM yyyy', 'th-TH') AS Field16,
        FORMAT(auctionDate07, 'dd MMMM yyyy', 'th-TH') AS Field17,
        FORMAT(auctionDate08, 'dd MMMM yyyy', 'th-TH') AS Field18,
        FORMAT(auctionDate09, 'dd MMMM yyyy', 'th-TH') AS Field19,
        FORMAT(auctionDate10, 'dd MMMM yyyy', 'th-TH') AS Field20,
        FORMAT(auctionDate11, 'dd MMMM yyyy', 'th-TH') AS Field21,
        FORMAT(auctionDate12, 'dd MMMM yyyy', 'th-TH') AS Field22,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field23,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 1) AS Field24,
        (SELECT full_name FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field25,
        (SELECT phone FROM [repossess_jai].[dbo].[jai_vw_staff_assignment] WHERE assginment_id = 2) AS Field26,
        receiver_name_display AS Field27,
        receiver_mailing_address AS Field28,letter_id
    FROM
        [repossess_jai].[dbo].[jai_vw_redemption_letter_transaction]
    WHERE
         letter_issued_times = 2
        AND status_code = 2220 /* don't forget change back to status_code 2210 */
        --AND letter_type_code IN ('C2CGY');
        AND letter_type_code IN ('C2C61GY', 'C2C65GY');

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_5]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_5]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('Auction','REPO','AUCT')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_5_1]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_5_1]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('Auction','REPO','AUCT')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_5_2]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_5_2]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('Auction','REPO','AUCT')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_5_3]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_Export_Print_4_5_3]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('Auction','REPO','AUCT')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_Print_4_6]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  or ALTER     PROCEDURE [dbo].[SP_Export_Print_4_6]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('Auction','REPO','AUCT')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Export_View_all_print_jobs]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE or ALTER PROCEDURE [dbo].[SP_Export_View_all_print_jobs]
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @Status VARCHAR(50) = NULL,
    @JobCode VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pr.[RunId]
       ,pr.[JobId]
       ,pj.[JobCode]
       ,pj.[JobName]
       ,pj.[StoredProcName]
       ,pj.[FileNameTemplate]
       ,pr.[StartedAt]
       ,pr.[EndedAt]
       ,pr.[Status]
       ,pr.[RowsExported]
       ,pr.[OutputFilePath]
       ,pr.[Message]
    FROM [JAI_DAILY_EXPORT].[dbo].[Export_PrintJobRun] pr
    INNER JOIN [JAI_DAILY_EXPORT].[dbo].[Export_PrintJob] pj
        ON pr.[JobId] = pj.[JobId]
    WHERE 1=1
        AND (@StartDate IS NULL OR CAST(pr.[StartedAt] AS DATE) >= @StartDate)
        AND (@EndDate IS NULL OR CAST(pr.[StartedAt] AS DATE) <= @EndDate)
        AND (@Status IS NULL OR pr.[Status] = @Status)
        AND (@JobCode IS NULL OR pj.[JobCode] = @JobCode)
    ORDER BY pr.[StartedAt] DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_C2C_CLEAR_AFTER]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_C2C_CLEAR_AFTER]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT	record_type	as 'record_type'
,	contract_number	as 'contract_number'
,	decrease_debt_amount	as 'decrease_debt_amount'
,	decrease_accrued_interest_amount	as 'decrease_accrued_interest_amount'
,	decrease_accrued_penalty_amount	as 'decrease_accrued_penalty_amount'
,	increase_debt_amount	as 'increase_debt_amount'
,	increase_accrued_interest_amount	as 'increase_accrued_interest_amount'
,	increase_accrued_penalty_amount	as 'increase_accrued_penalty_amount'
,	decrease_miscellaneous_amount	as 'decrease_miscellaneous_amount'
,	increase_miscellaneous_amount	as 'increase_miscellaneous_amount'
,	clear_pending_debt_amount	as 'clear_pending_debt_amount'
,	clear_pending_accrued_interest_amount	as 'clear_pending_accrued_interest_amount'
,	clear_pending_accrued_penalty_amount	as 'clear_pending_accrued_penalty_amount'
,	clear_pending_miscellaneous_amount	as 'clear_pending_miscellaneous_amount'
,	sale_assets_debt_amount	as 'sale_assets_debt_amount'
,	sale_assets_accrued_interest_amount	as 'sale_assets_accrued_interest_amount'
,	sale_assets_accrued_penalty_amount	as 'sale_assets_accrued_penalty_amount'
,	sale_assets_miscellaneous_amount	as 'sale_assets_miscellaneous_amount'
,	after_debt_amount	as 'after_debt_amount'
,	after_accrued_interest_amount	as 'after_accrued_interest_amount'
,	after_accrued_penalty_amount	as 'after_accrued_penalty_amount'
,	after_miscellaneous_amount	as 'after_miscellaneous_amount'
,	after_pending_amount	as 'after_pending_amount'
,	refund_amount	as 'refund_amount'
,	source_of_refund	as 'source_of_refund'
from repossess_jai.dbo.jai_vw_z_datalist_sor_crl_clear_after

END;

GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_C2C_CLEAR_AFTER_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_C2C_CLEAR_AFTER_RESULT]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
     FROM [repossess_jai].[dbo].[jai_vw_z_datalist_sor_crl_sale_car]
END;

GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_C2C_CLEAR_BEFORE]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_C2C_CLEAR_BEFORE]
AS
BEGIN
    SET NOCOUNT ON;

 SELECT	record_type	as 'record_type'
,	contract_number	as 'contract_number'
,	decrease_principal_amount	as 'decrease_principal_amount'
,	decrease_unearned_interest_amount	as 'decrease_unearned_interest_amount'
,	increase_principal_amount	as 'increase_principal_amount'
,	increase_unearned_interest_amount	as 'increase_unearned_interest_amount'
,	decrease_miscellaneous_amount	as 'decrease_miscellaneous_amount'
,	increase_miscellaneous_amount	as 'increase_miscellaneous_amount'
,	clear_pending_principal_amount	as 'clear_pending_principal_amount'
,	clear_pending_unearned_interest_amount	as 'clear_pending_unearned_interest_amount'
,	clear_pending_miscellaneous_amount	as 'clear_pending_miscellaneous_amount'
,	sale_assets_principal_amount	as 'sale_assets_principal_amount'
,	sale_assets_unearned_interest_amount	as 'sale_assets_unearned_interest_amount'
,	sale_assets_miscellaneous_amount	as 'sale_assets_miscellaneous_amount'
,	after_principal_amount	as 'after_principal_amount'
,	after_unearned_interest_amount	as 'after_unearned_interest_amount'
,	after_miscellaneous_amount	as 'after_miscellaneous_amount'
,	after_pending_amount	as 'after_pending_amount'
,	refund_amount	as 'refund_amount'
,	source_of_refund	as 'source_of_refund'
from repossess_jai.dbo.jai_vw_z_datalist_sor_c2c_clear_before
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_C2C_CLEAR_BEFORE_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_C2C_CLEAR_BEFORE_RESULT]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
     FROM [repossess_jai].[dbo].[jai_vw_z_datalist_sor_crl_sale_car]
END;

--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--SP_SaleOfRepo_C2C_INITIAL_DEBT_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT
--SP_SaleOfRepo_C2C_CLEAR_AFTER
--SP_SaleOfRepo_C2C_CLEAR_AFTER_RESULT
GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_C2C_INITIAL_DEBT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_C2C_INITIAL_DEBT]
AS
BEGIN
    SET NOCOUNT ON;
SELECT	record_type	as 'record_type'
,	contract_number	as 'contract_number'
,	initial_debt_amount	as 'initial_debt_amount'
,	initial_accrued_interest_amount	as 'initial_accrued_interest_amount'
,	initial_accrued_penalty_amount	as 'initial_accrued_penalty_amount'
,	new_interest_rate	as 'new_interest_rate'
,	new_penalty_rate	as 'new_penalty_rate'
from repossess_jai.dbo.jai_vw_z_datalist_sor_c2c_initial_debt
END;

GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_C2C_INITIAL_DEBT_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_C2C_INITIAL_DEBT_RESULT]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
     FROM [repossess_jai].[dbo].[jai_vw_z_datalist_sor_crl_sale_car]
END;

--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--SP_SaleOfRepo_C2C_INITIAL_DEBT
--SP_SaleOfRepo_C2C_CLEAR_AFTER
--SP_SaleOfRepo_C2C_CLEAR_AFTER_RESULT
GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_C2C_STATUS_SALE_CAR]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_C2C_STATUS_SALE_CAR]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
     FROM [repossess_jai].[dbo].[jai_vw_z_datalist_sor_crl_sale_car]
END;

--
--
--
--
--
--
--
--
--
--
--
--
--
--
--SP_SaleOfRepo_C2C_CLEAR_BEFORE
--SP_SaleOfRepo_C2C_CLEAR_BEFORE_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT
--SP_SaleOfRepo_C2C_CLEAR_AFTER
--SP_SaleOfRepo_C2C_CLEAR_AFTER_RESULT
GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_C2C_STATUS_SALE_CAR_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_C2C_STATUS_SALE_CAR_RESULT]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
     FROM [repossess_jai].[dbo].[jai_vw_z_datalist_sor_crl_sale_car]
END;

--
--
--
--
--
--
--
--
--
--
--
--
--
--SP_SaleOfRepo_C2C_STATUS_SALE_CAR
--SP_SaleOfRepo_C2C_CLEAR_BEFORE
--SP_SaleOfRepo_C2C_CLEAR_BEFORE_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT
--SP_SaleOfRepo_C2C_CLEAR_AFTER
--SP_SaleOfRepo_C2C_CLEAR_AFTER_RESULT
GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_CRL_CLEAR_AFTER]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_CRL_CLEAR_AFTER]
AS
BEGIN
    SET NOCOUNT ON;


    SELECT	record_type	as 'record_type'
,	contract_number	as 'contract_number'
,	decrease_debt_amount	as 'decrease_debt_amount'
,	decrease_accrued_interest_amount	as 'decrease_accrued_interest_amount'
,	decrease_accrued_penalty_amount	as 'decrease_accrued_penalty_amount'
,	increase_debt_amount	as 'increase_debt_amount'
,	increase_accrued_interest_amount	as 'increase_accrued_interest_amount'
,	increase_accrued_penalty_amount	as 'increase_accrued_penalty_amount'
,	decrease_miscellaneous_amount	as 'decrease_miscellaneous_amount'
,	increase_miscellaneous_amount	as 'increase_miscellaneous_amount'
,	clear_pending_debt_amount	as 'clear_pending_debt_amount'
,	clear_pending_accrued_interest_amount	as 'clear_pending_accrued_interest_amount'
,	clear_pending_accrued_penalty_amount	as 'clear_pending_accrued_penalty_amount'
,	clear_pending_miscellaneous_amount	as 'clear_pending_miscellaneous_amount'
,	sale_assets_debt_amount	as 'sale_assets_debt_amount'
,	sale_assets_accrued_interest_amount	as 'sale_assets_accrued_interest_amount'
,	sale_assets_accrued_penalty_amount	as 'sale_assets_accrued_penalty_amount'
,	sale_assets_miscellaneous_amount	as 'sale_assets_miscellaneous_amount'
,	after_debt_amount	as 'after_debt_amount'
,	after_accrued_interest_amount	as 'after_accrued_interest_amount'
,	after_accrued_penalty_amount	as 'after_accrued_penalty_amount'
,	after_miscellaneous_amount	as 'after_miscellaneous_amount'
,	after_pending_amount	as 'after_pending_amount'
,	refund_amount	as 'refund_amount'
,	source_of_refund	as 'source_of_refund'
from repossess_jai.dbo.jai_vw_z_datalist_sor_crl_clear_after


END;

GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_CRL_CLEAR_AFTER_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_CRL_CLEAR_AFTER_RESULT]
AS
BEGIN
    SET NOCOUNT ON;

select	decrease_principal_amount	as 'decrease_principal_amount'
,	decrease_unearned_interest_amount	as 'decrease_unearned_interest_amount'
,	decrease_unbilled_vat_amount	as 'decrease_unbilled_vat_amount'
,	decrease_unpaid_bill_vat_amount	as 'decrease_unpaid_bill_vat_amount'
,	decrease_accrued_penalty_amount	as 'decrease_accrued_penalty_amount'
,	decrease_collection_fee_amount	as 'decrease_collection_fee_amount'
,	decrease_field_collection_fee_amount	as 'decrease_field_collection_fee_amount'
,	increase_principal_amount	as 'increase_principal_amount'
,	increase_unearned_interest_amount	as 'increase_unearned_interest_amount'
,	increase_unbilled_vat_amount	as 'increase_unbilled_vat_amount'
,	increase_unpaid_bill_vat_amount	as 'increase_unpaid_bill_vat_amount'
,	increase_accrued_penalty_amount	as 'increase_accrued_penalty_amount'
,	increase_collection_fee_amount	as 'increase_collection_fee_amount'
,	increase_field_collection_fee_amount	as 'increase_field_collection_fee_amount'
,	pending_amount_principal_amount	as 'clear_pending_principal_amount'
,	pending_amount_unearned_interest_amount	as 'clear_pending_unearned_interest_amount'
,	pending_amount_unpaid_bill_vat_amount	as 'clear_pending_unpaid_bill_vat_amount'
,	pending_amount_accrued_penalty_amount	as 'clear_pending_accrued_penalty_amount'
,	pending_amount_field_collection_fee_amount	as 'clear_pending_collection_fee_amount'
,	pending_amount_collection_fee_amount	as 'clear_pending_field_collection_fee_amount'
,	sale_principal_amount	as 'sale_principal_amount'
,	sale_unearned_interest_amount	as 'sale_unearned_interest_amount'
,	sale_unpaid_bill_vat_amount	as 'sale_unpaid_bill_vat_amount'
,	sale_accrued_penalty_amount	as 'sale_accrued_penalty_amount'
,	sale_collection_fee_amount	as 'sale_collection_fee_amount'
,	sale_field_collection_fee_amount	as 'sale_field_collection_fee_amount'
,	sale_assets_principal_amount	as 'sale_assets_principal_amount'
,	sale_assets_unearned_interest_amount	as 'sale_assets_unearned_interest_amount'
,	sale_assets_unpaid_bill_vat_amount	as 'sale_assets_unpaid_bill_vat_amount'
,	sale_assets_accrued_penalty_amount	as 'sale_assets_accrued_penalty_amount'
,	sale_assets_collection_fee_amount	as 'sale_assets_collection_fee_amount'
,	sale_assets_field_collection_fee_amount	as 'sale_assets_field_collection_fee_amount'
,	after_principal_amount	as 'after_principal_amount'
,	after_unearned_interest_amount	as 'after_unearned_interest_amount'
,	after_unbilled_vat_amount	as 'after_unbilled_vat_amount'
,	after_unpaid_bill_vat_amount	as 'after_unpaid_bill_vat_amount'
,	after_accrued_penalty_amount	as 'after_accrued_penalty_amount'
,	after_collection_fee_amount	as 'after_collection_fee_amount'
,	after_field_collection_fee_amount	as 'after_field_collection_fee_amount'
,	after_pending_amount	as 'after_pending_amount'
,	refund_amount	as 'refund_amount'
,	source_of_refund	as 'source_of_refund'


     FROM [repossess_jai].[dbo].jai_vw_z_datalist_sor_c2c_sale_car
END;

GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_CRL_CLEAR_BEFORE]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_CRL_CLEAR_BEFORE]
AS
BEGIN
    SET NOCOUNT ON;

        select	contract_number	as 'contract_number'
,	decrease_principal_amount	as 'decrease_principal_amount'
,	decrease_accrued_interest_amount	as 'decrease_accrued_interest_amount'
,	increase_principal_amount	as 'increase_principal_amount'
,	increase_accrued_interest_amount	as 'increase_accrued_interest_amount'
,	decrease_miscellaneous_amount	as 'decrease_miscellaneous_amount'
,	increase_miscellaneous_amount	as 'increase_miscellaneous_amount'
,	clear_pending_principal_amount	as 'clear_pending_principal_amount'
,	clear_pending_accrued_interest_amount	as 'clear_pending_accrued_interest_amount'
,	clear_pending_miscellaneous_amount	as 'clear_pending_miscellaneous_amount'
,	sale_assets_principal_amount	as 'sale_assets_principal_amount'
,	sale_assets_accrued_interest_amount	as 'sale_assets_accrued_interest_amount'
,	sale_assets_miscellaneous_amount	as 'sale_assets_miscellaneous_amount'
,	after_principal_amount	as 'after_principal_amount'
,	after_accrued_interest_amount	as 'after_accrued_interest_amount'
,	after_miscellaneous_amount	as 'after_miscellaneous_amount'
,	after_pending_amount	as 'after_pending_amount'
,	refund_amount	as 'refund_amount'
,	source_of_refund	as 'source_of_refund'

     FROM [repossess_jai].[dbo].jai_vw_z_datalist_sor_crl_clear_before
END;

GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_CRL_CLEAR_BEFORE_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_CRL_CLEAR_BEFORE_RESULT]
AS
BEGIN
    SET NOCOUNT ON;

        select	contract_number	as 'contract_number'
,	decrease_principal_amount	as 'decrease_principal_amount'
,	decrease_accrued_interest_amount	as 'decrease_accrued_interest_amount'
,	increase_principal_amount	as 'increase_principal_amount'
,	increase_accrued_interest_amount	as 'increase_accrued_interest_amount'
,	decrease_miscellaneous_amount	as 'decrease_miscellaneous_amount'
,	increase_miscellaneous_amount	as 'increase_miscellaneous_amount'
,	clear_pending_principal_amount	as 'clear_pending_principal_amount'
,	clear_pending_accrued_interest_amount	as 'clear_pending_accrued_interest_amount'
,	clear_pending_miscellaneous_amount	as 'clear_pending_miscellaneous_amount'
,	sale_assets_principal_amount	as 'sale_assets_principal_amount'
,	sale_assets_accrued_interest_amount	as 'sale_assets_accrued_interest_amount'
,	sale_assets_miscellaneous_amount	as 'sale_assets_miscellaneous_amount'
,	after_principal_amount	as 'after_principal_amount'
,	after_accrued_interest_amount	as 'after_accrued_interest_amount'
,	after_miscellaneous_amount	as 'after_miscellaneous_amount'
,	after_pending_amount	as 'after_pending_amount'
,	refund_amount	as 'refund_amount'
,	source_of_refund	as 'source_of_refund'

     FROM [repossess_jai].[dbo].jai_vw_z_datalist_sor_crl_clear_before
END;

GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_CRL_INITIAL_DEBT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_CRL_INITIAL_DEBT]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT	record_type	as 'record_type'
,	contract_number	as 'contract_number'
,	initial_debt_amount	as 'initial_debt_amount'
,	initial_accrued_interest_amount	as 'initial_accrued_interest_amount'
,	initial_accrued_penalty_amount	as 'initial_accrued_penalty_amount'
,	new_interest_rate	as 'new_interest_rate'
,	new_penalty_rate	as 'new_penalty_rate'
from repossess_jai.dbo.jai_vw_z_datalist_sor_crl_initial_debt

END;
GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_CRL_INITIAL_DEBT_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_CRL_INITIAL_DEBT_RESULT]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
     FROM [repossess_jai].[dbo].[jai_vw_z_datalist_sor_crl_sale_car]
END;

--
--
--
--
--
--
--
--
--
--SP_SaleOfRepo_CRL_INITIAL_DEBT
--SP_SaleOfRepo_CRL_CLEAR_AFTER
--SP_SaleOfRepo_CRL_CLEAR_AFTER_RESULT
--SP_SaleOfRepo_C2C_STATUS_SALE_CAR_RESULT
--SP_SaleOfRepo_C2C_STATUS_SALE_CAR
--SP_SaleOfRepo_C2C_CLEAR_BEFORE
--SP_SaleOfRepo_C2C_CLEAR_BEFORE_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT
--SP_SaleOfRepo_C2C_CLEAR_AFTER
--SP_SaleOfRepo_C2C_CLEAR_AFTER_RESULT
GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_CRL_STATUS_SALE_CAR]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_CRL_STATUS_SALE_CAR]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        decrease_principal_amount AS decrease_principal_amount,
        decrease_accrued_interest_amount AS decrease_accrued_interest_amount,
        decrease_accrued_penalty_amount AS decrease_accrued_penalty_amount,
        decrease_collection_fee_amount AS decrease_collection_fee_amount,
        increase_principal_amount AS increase_principal_amount,
        increase_accrued_interest_amount AS increase_accrued_interest_amount,
        increase_accrued_penalty_amount AS increase_accrued_penalty_amount,
        increase_collection_fee_amount AS increase_collection_fee_amount,
        pending_amount_principal_amount AS clear_pending_principal_amount,
        pending_amount_accrued_interest_amount AS clear_pending_accrued_interest_amount,
        pending_amount_accrued_penalty_amount AS clear_pending_accrued_penalty_amount,
        pending_amount_collection_fee_amount AS clear_pending_collection_fee_amount,
        sale_principal_amount AS sale_principal_amount,
        sale_accrued_interest_amount AS sale_accrued_interest_amount,
        sale_accrued_penalty_amount AS sale_accrued_penalty_amount,
        sale_collection_fee_amount AS sale_collection_fee_amount,
        sale_assets_principal_amount AS sale_assets_principal_amount,
        sale_assets_accrued_interest_amount AS sale_assets_accrued_interest_amount,
        sale_assets_accrued_penalty_amount AS sale_assets_accrued_penalty_amount,
        sale_assets_collection_fee_amount AS sale_assets_collection_fee_amount,
        after_principal_amount AS after_principal_amount,
        after_accrued_interest_amount AS after_accrued_interest_amount,
        after_accrued_penalty_amount AS after_accrued_penalty_amount,
        after_collection_fee_amount AS after_collection_fee_amount,
        after_pending_amount AS after_pending_amount,
        refund_amount AS refund_amount,
        source_of_refund AS source_of_refund
     FROM [repossess_jai].[dbo].[jai_vw_z_datalist_sor_crl_sale_car]
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_SaleOfRepo_CRL_STATUS_SALE_CAR_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_SaleOfRepo_CRL_STATUS_SALE_CAR_RESULT]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        decrease_principal_amount AS decrease_principal_amount,
        decrease_accrued_interest_amount AS decrease_accrued_interest_amount,
        decrease_accrued_penalty_amount AS decrease_accrued_penalty_amount,
        decrease_collection_fee_amount AS decrease_collection_fee_amount,
        increase_principal_amount AS increase_principal_amount,
        increase_accrued_interest_amount AS increase_accrued_interest_amount,
        increase_accrued_penalty_amount AS increase_accrued_penalty_amount,
        increase_collection_fee_amount AS increase_collection_fee_amount,
        pending_amount_principal_amount AS clear_pending_principal_amount,
        pending_amount_accrued_interest_amount AS clear_pending_accrued_interest_amount,
        pending_amount_accrued_penalty_amount AS clear_pending_accrued_penalty_amount,
        pending_amount_collection_fee_amount AS clear_pending_collection_fee_amount,
        sale_principal_amount AS sale_principal_amount,
        sale_accrued_interest_amount AS sale_accrued_interest_amount,
        sale_accrued_penalty_amount AS sale_accrued_penalty_amount,
        sale_collection_fee_amount AS sale_collection_fee_amount,
        sale_assets_principal_amount AS sale_assets_principal_amount,
        sale_assets_accrued_interest_amount AS sale_assets_accrued_interest_amount,
        sale_assets_accrued_penalty_amount AS sale_assets_accrued_penalty_amount,
        sale_assets_collection_fee_amount AS sale_assets_collection_fee_amount,
        after_principal_amount AS after_principal_amount,
        after_accrued_interest_amount AS after_accrued_interest_amount,
        after_accrued_penalty_amount AS after_accrued_penalty_amount,
        after_collection_fee_amount AS after_collection_fee_amount,
        after_pending_amount AS after_pending_amount,
        refund_amount AS refund_amount,
        source_of_refund AS source_of_refund
     FROM [repossess_jai].[dbo].[jai_vw_z_datalist_sor_crl_sale_car]
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_CONTRACT_STATUS_AUCT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_UPDATE_CONTRACT_STATUS_AUCT]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('AUCT')
	--where contract_status_code in ('REPO','AUCT')
	--where contract_status_code in ('AAAAAA')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_CONTRACT_STATUS_AUCT_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_UPDATE_CONTRACT_STATUS_AUCT_RESULT]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('AUCT')
	--where contract_status_code in ('REPO','AUCT')
	--where contract_status_code in ('AAAAAA')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_CONTRACT_STATUS_REPO]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_UPDATE_CONTRACT_STATUS_REPO]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('REPO')
	--where contract_status_code in ('REPO','AUCT')
	--where contract_status_code in ('AAAAAA')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_CONTRACT_STATUS_REPO_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_UPDATE_CONTRACT_STATUS_REPO_RESULT]
--@StartDate DATE
AS
BEGIN
SET NOCOUNT ON;

    -- Insert statements for procedure here
	select account_number, contract_status_code FROM repossess_jai.dbo.jai_contracts 
	where contract_status_code in ('REPO')
	--where contract_status_code in ('REPO','AUCT')
	--where contract_status_code in ('AAAAAA')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_SubStatus]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_UPDATE_SubStatus]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
     FROM [repossess_jai].[dbo].[jai_vw_z_datalist_sor_crl_sale_car]
END;

--
--
--
--
--
--SP_UPDATE-SubStatus_RESULT
--SP_SaleOfRepo_CRL_CLEAR_BEFORE
--SP_SaleOfRepo_CRL_CLEAR_BEFORE_RESULT
--SP_SaleOfRepo_CRL_INITIAL_DEBT_RESULT
--SP_SaleOfRepo_CRL_INITIAL_DEBT
--SP_SaleOfRepo_CRL_CLEAR_AFTER
--SP_SaleOfRepo_CRL_CLEAR_AFTER_RESULT
--SP_SaleOfRepo_C2C_STATUS_SALE_CAR_RESULT
--SP_SaleOfRepo_C2C_STATUS_SALE_CAR
--SP_SaleOfRepo_C2C_CLEAR_BEFORE
--SP_SaleOfRepo_C2C_CLEAR_BEFORE_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT
--SP_SaleOfRepo_C2C_CLEAR_AFTER
--SP_SaleOfRepo_C2C_CLEAR_AFTER_RESULT
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_SubStatus_RESULT]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[SP_UPDATE_SubStatus_RESULT]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
     FROM [repossess_jai].[dbo].[jai_vw_z_datalist_sor_crl_sale_car]
END;

--
--
--
--
--
--
--SP_SaleOfRepo_CRL_CLEAR_BEFORE
--SP_SaleOfRepo_CRL_CLEAR_BEFORE_RESULT
--SP_SaleOfRepo_CRL_INITIAL_DEBT_RESULT
--SP_SaleOfRepo_CRL_INITIAL_DEBT
--SP_SaleOfRepo_CRL_CLEAR_AFTER
--SP_SaleOfRepo_CRL_CLEAR_AFTER_RESULT
--SP_SaleOfRepo_C2C_STATUS_SALE_CAR_RESULT
--SP_SaleOfRepo_C2C_STATUS_SALE_CAR
--SP_SaleOfRepo_C2C_CLEAR_BEFORE
--SP_SaleOfRepo_C2C_CLEAR_BEFORE_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT_RESULT
--SP_SaleOfRepo_C2C_INITIAL_DEBT
--SP_SaleOfRepo_C2C_CLEAR_AFTER
--SP_SaleOfRepo_C2C_CLEAR_AFTER_RESULT
GO
/****** Object:  StoredProcedure [dbo].[usp_Export_LMSJobRun_End]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Fix #2: Change UTC to local Bangkok time
CREATE or ALTER PROCEDURE [dbo].[usp_Export_LMSJobRun_End]
    @RunId BIGINT,
    @Status NVARCHAR(50),
    @Rows INT = NULL,
    @OutputFilePath NVARCHAR(1000) = NULL,
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE dbo.Export_LMSJobRun
    SET EndedAt = SYSDATETIME(),              -- Changed from SYSUTCDATETIME()
        Status = @Status,
        RowsExported = @Rows,
        OutputFilePath = @OutputFilePath,
        Message = @Message
    WHERE RunId = @RunId;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Export_LMSJobRun_Error]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[usp_Export_LMSJobRun_Error]
@RunId BIGINT,
@Stage NVARCHAR(100),
@ErrorMessage NVARCHAR(MAX)
AS
BEGIN
SET NOCOUNT ON;
INSERT dbo.Export_LMSJobRunError (RunId, Stage, ErrorMessage)
VALUES (@RunId, @Stage, @ErrorMessage);
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Export_LMSJobRun_Start]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Fix #1: Add StartedAt timestamp
CREATE or ALTER PROCEDURE [dbo].[usp_Export_LMSJobRun_Start]
    @JobId INT,
    @RunId BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT dbo.Export_LMSJobRun (JobId, StartedAt, Status) 
    VALUES (@JobId, SYSDATETIME(), 'Started');  -- Added StartedAt with local time
    
    SET @RunId = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Export_PrintJobRun_End]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[usp_Export_PrintJobRun_End]
@RunId BIGINT,
@Status NVARCHAR(50),
@Rows INT = NULL,
@OutputFilePath NVARCHAR(1000) = NULL,
@Message NVARCHAR(MAX) = NULL
AS
BEGIN
SET NOCOUNT ON;
UPDATE dbo.Export_PrintJobRun
SET EndedAt = SYSUTCDATETIME(),
Status = @Status,
RowsExported = @Rows,
OutputFilePath = @OutputFilePath,
Message = @Message
WHERE RunId = @RunId;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Export_PrintJobRun_Error]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[usp_Export_PrintJobRun_Error]
@RunId BIGINT,
@Stage NVARCHAR(100),
@ErrorMessage NVARCHAR(MAX)
AS
BEGIN
SET NOCOUNT ON;
INSERT dbo.Export_PrintJobRunError (RunId, Stage, ErrorMessage, ErrorAt)
VALUES (@RunId, @Stage, @ErrorMessage, GETDATE());
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Export_PrintJobRun_Start]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[usp_Export_PrintJobRun_Start]
@JobId INT,
@RunId BIGINT OUTPUT
AS
BEGIN
SET NOCOUNT ON;
INSERT dbo.Export_PrintJobRun (JobId, Status, StartedAt) VALUES (@JobId, 'Started', GETDATE());
SET @RunId = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ExportJobRun_End]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[usp_ExportJobRun_End]
@RunId BIGINT,
@Status NVARCHAR(50),
@Rows INT = NULL,
@OutputFilePath NVARCHAR(1000) = NULL,
@Message NVARCHAR(MAX) = NULL
AS
BEGIN
SET NOCOUNT ON;
UPDATE dbo.ExportJobRun
SET EndedAt = SYSUTCDATETIME(),
Status = @Status,
RowsExported = @Rows,
OutputFilePath = @OutputFilePath,
Message = @Message
WHERE RunId = @RunId;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ExportJobRun_Error]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[usp_ExportJobRun_Error]
@RunId BIGINT,
@Stage NVARCHAR(100),
@ErrorMessage NVARCHAR(MAX)
AS
BEGIN
SET NOCOUNT ON;
INSERT dbo.ExportJobRunError (RunId, Stage, ErrorMessage)
VALUES (@RunId, @Stage, @ErrorMessage);
END
GO
/****** Object:  StoredProcedure [dbo].[usp_ExportJobRun_Start]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[usp_ExportJobRun_Start]
@JobId INT,
@RunId BIGINT OUTPUT
AS
BEGIN
SET NOCOUNT ON;
INSERT dbo.ExportJobRun (JobId, Status) VALUES (@JobId, 'Started');
SET @RunId = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateDataStatus]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[usp_UpdateDataStatus]
    @RunId BIGINT,
    @Status INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the status in your source table (e.g., 'YourSourceTable')
    -- by joining with the log table that connects RunId to your data's primary key.
    UPDATE T
    SET Status = @Status
    FROM dbo.YourSourceTable T
    JOIN dbo.ExportDataLog L ON T.YourPrimaryKey = L.SourceTableKey
    WHERE L.RunId = @RunId;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateSourceDataStatus]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE or ALTER PROCEDURE [dbo].[usp_UpdateSourceDataStatus]
    @TableName NVARCHAR(255),
    @PkColumnName NVARCHAR(255),
    @Status INT,
    @Ids dbo.IdList READONLY
AS
BEGIN
    SET NOCOUNT ON;

    -- Exit if there are no IDs to process
    IF NOT EXISTS (SELECT 1 FROM @Ids)
    BEGIN
        RETURN;
    END

    -- Build the dynamic SQL UPDATE statement
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'UPDATE ' + QUOTENAME(@TableName) +
               N' SET Status_code = @Status, ' +
               N' exported_date = CASE WHEN @Status = 2210 THEN GETDATE() ELSE exported_date END, ' +
               N' sent_date = CASE WHEN @Status = 2220 THEN GETDATE() ELSE sent_date END ' +
               N' WHERE ' + QUOTENAME(@PkColumnName) + N' IN (SELECT ID FROM @Ids);';

    -- Execute the dynamic SQL
    EXEC sp_executesql @sql,
        N'@Status INT, @Ids dbo.IdList READONLY',
        @Status = @Status,
        @Ids = @Ids;
END
GO
/****** Object:  StoredProcedure [dbo].[uspExportLMS_GetJobsToRun]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 3) Helper proc: return jobs that should run "now"
--   - @CurrentLocalTime should be Bangkok local time
--   - @WindowMinutes = how many minutes before/after to treat as "this slot"
CREATE or ALTER PROCEDURE [dbo].[uspExportLMS_GetJobsToRun]
    @CurrentLocalTime DATETIME2(0),
    @WindowMinutes    INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @today DATE = CONVERT(date, @CurrentLocalTime);

    ;WITH CteWindows AS (
        SELECT
            s.ScheduleId,
            s.JobId,
            s.RunTime,
            s.LastRunDate,
            -- Combine today's date and the configured RunTime into a datetime2(0)
            DATEADD(
                MINUTE,
                -@WindowMinutes,
                CAST(
                    CONVERT(char(10), CONVERT(date, @CurrentLocalTime), 120)
                    + ' '
                    + CONVERT(char(8), s.RunTime, 108)
                    AS datetime2(0)
                )
            ) AS WindowStart,
            DATEADD(
                MINUTE,
                @WindowMinutes,
                CAST(
                    CONVERT(char(10), CONVERT(date, @CurrentLocalTime), 120)
                    + ' '
                    + CONVERT(char(8), s.RunTime, 108)
                    AS datetime2(0)
                )
            ) AS WindowEnd
        FROM [JAI_DAILY_EXPORT].[dbo].[Export_LMSSchedule] s
        WHERE s.IsActive = 1
    )
    SELECT
        j.JobId,
        j.JobCode,
        j.JobName,
        j.StoredProcName,
        j.FileNameTemplate,
        j.SheetName,
        j.IsActive,
        j.ExecuteOrder,
        ISNULL(j.OutputSubfolder, N'')          AS OutputSubfolder,
        120                                     AS CommandTimeoutSec,
        j.SourceTableName,
        j.PrimaryKeyColumnName,
        ISNULL(j.OutputRootKey, N'PRINTFOLDER') AS OutputRootKey,
        w.ScheduleId
    FROM CteWindows w
    JOIN [JAI_DAILY_EXPORT].[dbo].[Export_LMSJob] j
      ON j.JobId = w.JobId
    WHERE j.IsActive = 1
      AND @CurrentLocalTime BETWEEN w.WindowStart AND w.WindowEnd
      AND (w.LastRunDate IS NULL OR w.LastRunDate < @today);
END;
GO
/****** Object:  StoredProcedure [dbo].[uspExportLMS_MarkScheduleRun]    Script Date: 12/24/2025 12:27:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 4) Helper proc: mark schedule as executed for today
CREATE or ALTER PROCEDURE [dbo].[uspExportLMS_MarkScheduleRun]
    @ScheduleId INT,
    @RunDate    DATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [JAI_DAILY_EXPORT].[dbo].[Export_LMSSchedule]
    SET LastRunDate = @RunDate,
        UpdatedAt   = SYSUTCDATETIME()
    WHERE ScheduleId = @ScheduleId;
END;
GO
