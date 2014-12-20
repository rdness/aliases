#! /usr/bin/perl

#############################################################################################################
##
##	bar.pl 
##	By: David Wei
##
#############################################################################################################
##	This script allows you to backup important files or directories. 
##
##	To back up individual files, include the -f flag when calling the script. The backup file is stored 
##	in the current directory.
##
##	Example:
##
##		perl bar.pl -f singleFile.txt
##
##	To backup directories no flags are needed. This script will compress the current directory into a tar.gz
##	file and store it into the directory provided below. By default, the tar file will be named whatever
##	the directory is named, but if you desire a different name, you may include that as a command line 
##	argument.
##
##	Example:
##		perl bar.pl
##		or
##		perl bar.pl desiredName
##		
##	To reinstate an archive that has been stored away, include the -r flag. The script will retrieve the
##	the archived file from your backup directory, create a folder with its name in the current directory
##	and unarchive all the files into that directory.
##
##	Example:
##		perl bar.pl -r archivedFile
## 
##	To begin using this script, enter the directory where you want your files backed up in.
##	Note, please omit the last backslash in the pathname.
$backupPath = "/cygdrive/c/Users/david/Documents";


## Includes files needed to get directory information.
use Cwd;
use File::Basename;


## Switches between file mode, and directory mode
if ($ARGV[0] eq "-f")
{
	system(`cp $ARGV[1] $ARGV[1].bak`);
	print "\nFinished Backing up $ARGV[1]\n\n";
}
elsif($ARGV[0] eq "-r")
{
	if ($ARGV[1]) 
	{
		$name = $ARGV[1];

		unless (-e "$backupPath/backup/$name") 
		{
			print "\nUSAGE: \n";
			print "\nTo archive a signal file and place it in the current directory, use:";
			print "\n	perl bar.pl -f singleFile.txt";
			print "\nTo archive an entire directory, use:";
			print "\n	perl bar.pl";
			print "\nOr to specify a name different than the name of the current directory";
			print "\n	perl bar.pl desiredName";
			print "\nTo retrieve an archive and place it into a new folder in the current directory";
			print "\n	perl bar.pl -r archiveName\n\n"; 
			exit;
		}

			## Reads the file info.txt to see which backup number we are currently on.
			open (FILE, "$backupPath/backup/$name/info.txt") or die $!;
	
			$line = <FILE>;
	
			close FILE;
	
			## Adds one to the current backup number.
			$num = substr($line, 19);
			
			## Removes the newline character. Needed, cause $num will remain a string, and wont become a number.
			chomp($num);

			if(-d "$name")
			{
				print "\nERROR: Directory $name already exists. \nPlease remove the directory and then continue\n";
				exit;
			}

			## Creates a directory, in current directory, to unzip archived files into.
			system("mkdir $name");

			## Copies the latest backup to the directory.
			system("cp $backupPath/backup/$name/$name.bak$num.tar.gz $name");

			## Unarchives the archive in the directory.
			system("tar xvfz $name/$name.bak$num.tar.gz -C $name");

			## Removes the archive afterwards.
			system("rm $name/$name.bak$num.tar.gz");			
	}
	else
	{
		print "\nUSAGE: \n";
		print "\nTo archive a signal file and place it in the current directory, use:";
		print "\n	perl bar.pl -f singleFile.txt";
		print "\nTo archive an entire directory, use:";
		print "\n	perl bar.pl";
		print "\nOr to specify a name different than the name of the current directory";
		print "\n	perl bar.pl desiredName";
		print "\nTo retrieve an archive and place it into a new folder in the current directory";
		print "\n	perl bar.pl -r archiveName\n\n"; 
		exit;
	}

	
}
elsif($ARGV[0] eq "")
{
	## If a name is given in the command line, then use it, otherwise use the name of the directory.
	if ($ARGV[0]) 
	{
		$name = $ARGV[0];
	}
	else
	{
		$pathVar = getcwd();
		$name = basename($pathVar);
	}
	## Checks and creates the backup directory in your workspace.
	unless (-e "$backupPath/backup") 
	{	
		system("mkdir $backupPath/backup");	
	}

	## Checks to see if the folder to be backuped exists. If it doesn't, it makes the folder and adds info.txt
	unless (-e "$backupPath/backup/$name") 
	{
		system("mkdir $backupPath/backup/$name");
		system("touch $backupPath/backup/$name/info.txt");
	}
	
	## Reads the file info.txt to see which backup number we are currently on.
	open (FILE, "$backupPath/backup/$name/info.txt") or die $!;
	
	$line = <FILE>;
	
	close FILE;
	
	## Adds one to the current backup number.
	$num = substr($line, 19);
	$num += 1;
	
	## Helpful print statements
	print "\nIncluding the following files into $name.bak$num.tar.gz\n";


	## Tars the files in the current directory, and moves it your backup directory.
	system("tar -pcvzf $name.bak$num.tar.gz .");

	print "\nMoving $name.bak$num.tar.gz to Directory: \n$backupPath/backup/$name \n";
	system("mv $name.bak$num.tar.gz $backupPath/backup/$name");
	
	## Lists all the backups in the directory so they can be written to the info.txt file
	@list = `ls -t $backupPath/backup/$name/*.tar.gz`;
	
	print "\nWriting info.txt\n";

	## Rewrites the info.txt file.
	open (FILE, ">$backupPath/backup/$name/info.txt") or die $!;
	
	print FILE "Number of Backups: $num\n\n";
	foreach (@list)
	{
		print FILE basename($_);
	}
	close FILE;
	
	print "\nFiles backed up\n\n";
	
	system(`echo "\nLast updated:" >> $backupPath/backup/$name/info.txt`);
	system(`date >> $backupPath/backup/$name/info.txt`);
}
else
{
	print "\nUSAGE: \n";
	print "\nTo archive a signal file and place it in the current directory, use:";
	print "\n	perl bar.pl -f singleFile.txt";
	print "\nTo archive an entire directory, use:";
	print "\n	perl bar.pl";
	print "\nOr to specify a name different than the name of the current directory";
	print "\n	perl bar.pl desiredName";
	print "\nTo retrieve an archive and place it into a new folder in the current directory";
	print "\n	perl bar.pl -r archiveName\n\n"; 
	exit;
}
