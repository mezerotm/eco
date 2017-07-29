/*
	testing data for mysql database for project eco
*/

CALL create_user('njtuley@aol.com', 'nicholas', 'tuley');
CALL create_user('dtuley@aol.com', 'daniel', 'tuley');

CALL add_friend('njtuley@aol.com', 'dtuley@aol.com');
CALL confirm_friend('njtuley@aol.com', 'dtuley@aol.com');