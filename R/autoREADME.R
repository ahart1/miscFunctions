#' @title Auto generate or update README
#' @description Auto generate or update a README file in the specified directory. Existing README files MUST contain a File and Folder table with at least one blank line for the auto-update to work.
#'
#' @param dirREADME A string specifying the directory to auto generate or update a README file, no default. If updating an existing file, the README must already contain a File and Folder table preceeded by a table.
#' @param title An optional argument (string) to provide a new title when generating a README file for the first time, default = "".
#' @param description An optional argument (string) to provide a description to follow the title when generating a new README file, default = "".
#'
#' @return Generates new/updated README file in specified dirREADME directory.

autoREADME <- function(dirREADME = NULL, title = "", description =""){
  # print(here::here())
  # setwd(here::here())
  # setwd("../..") # Move to top directory (i.e. 1 parent to current directory)
  # setwd(paste(getwd(), dirREADME, sep="/"))
  # # setwd(paste("/home/runner/work/", dirREADME, sep="/"))
  # print("newdirectory")
  # print(getwd())
  ##### Get updated file info for README #####
  fileList <- NULL
  # Generate updated list of files and sub-directories in repo
  fileList$File <- list.files(dirREADME,recursive=T, full.names = T)
  fileList$File <- c(fileList$File, list.dirs(dirREADME, recursive=T, full.names=T))
  print(list.dirs(dirREADME, recursive=TRUE, full.names=TRUE))
  # Filter out repo part of filename
  fileList$File <- gsub(paste(dirREADME, "/", sep=""),"", fileList$File)
  # Remove dirREADME directory from list
  fileList$File <- fileList$File[-which(fileList$File==dirREADME)]

  print("File names here")
  print(fileList$File)

  # Split filenames
  fileSplit <- strsplit(fileList$File, "/", fixed=T)

  # Pull unique files at top directory level for the current repository
  uniqueFile <- sapply(fileSplit,"[[",1) %>% unique()

  # Use strsplit() to ID files vs. sub-directories
  index <- strsplit(uniqueFile, ".", fixed=TRUE)
  fileIndex <- which(lengths(index) > 1)
  folderIndex <- which(lengths(index) == 1)

  # Final list of file and folder names in this directory
  fileNamesTemp <- uniqueFile[fileIndex]
  folderNames <- uniqueFile[folderIndex]

  fileNames <- fileNamesTemp[which(grepl("README", fileNamesTemp, fixed = TRUE) ==FALSE)] # Remove README file(s) from file list
  fileNames <- fileNames[which(grepl(".Rproj", fileNames, fixed = TRUE) ==FALSE)] # Remove .Rproj file from file list

  # Check if all upper case (assume all upper case names are files rather than folders even if no file extension)
  capIndex <- which(folderNames == toupper(folderNames)) # Check which names are the same when entire name is capitalized
  fileNames <- c(fileNames, folderNames[capIndex])
  fileNames <- sort(fileNames) # Resort alphabetically
  folderNames <- c(folderNames[-capIndex])

  ##### Pull info from existing README (if none exists skip this step) #####
  if(fileNamesTemp[which(grepl("README", fileNamesTemp, fixed = TRUE) ==TRUE)] %>% length() >0){

    # Read in info from existing README.md
    existingREADME <- readLines(con= paste(dirREADME, "README.md", sep="/"))

    # ID headers
    titleLines <- which(grepl("###", existingREADME, fixed=TRUE)==TRUE) # ID lines with header text

    fileTabTop <- which(grepl("| File | Description |", existingREADME, fixed=TRUE)==TRUE) # ID line where file table starts
    sortFileLines <- sort(c(titleLines,fileTabTop)) # Make vector of top of file table & title lines
    sortFileLinesIndex <- which(sortFileLines < fileTabTop) %>% max() # Pick next smallest title line as the fileTab title
    fileTitle <- sortFileLines[sortFileLinesIndex]

    folderTabTop <- which(grepl("| Folder | Description |", existingREADME, fixed=TRUE)==TRUE) # ID line where folder table starts
    sortFolderLines <- sort(c(titleLines,folderTabTop)) # Make vector of top of folder table & title lines
    sortFolderLinesIndex <- which(sortFolderLines < folderTabTop) %>% max() # Pick next smallest title line as the fileTab title
    folderTitle <- sortFolderLines[sortFolderLinesIndex]

    # Fill in new README title and description from existing README
    write(existingREADME[1:titleLines[2]-1],file=paste(dirREADME,"README.md",sep="/"),append=FALSE)

    # Fill in tables
    if(fileTabTop < folderTabTop){ # If existing file table listed first autofill this information first
      # If there are headers after the README title but before the file table and folder table fill them in here
      if(length(titleLines > 3) & titleLines[2] != folderTitle & titleLines[2] != fileTitle){
        write(existingREADME[titleLines[2]:fileTitle-1], file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # If extra title not located here this just adds another empty line
      }


      ### File table
      # Add table header and description for file table
      write(existingREADME[fileTitle:fileTabTop], file=paste(dirREADME,"README.md",sep="/"), append=TRUE)

      # Add divider for formatting
      write("| ----------- | ----------- |", file=paste(dirREADME,"README.md",sep="/"), append=TRUE)

      # Pull out existing table lines between fileTabTop and following header
      existingFiles <- existingREADME[(fileTabTop+1):(titleLines[which(titleLines == fileTitle)+1]-2)]
      if("" %in% existingFiles){ # If no existing files in README skip to fill in with new files
        for(ifile in fileNames){
          write(paste0("| ",ifile," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name without description
        }
      } else{ # Populate mix of old & new files
        splitExistingFiles <- strsplit(existingFiles, "| ", fixed=TRUE)
        existingFileName <- sapply(splitExistingFiles,"[[",2) %>% strsplit(., " ", fixed=TRUE) # Remove space following file name
        checkExistingFiles <- existingFileName[which(existingFileName %in% uniqueFile)]

        # Populate table
        for(ifile in fileNames){
          if(ifile %in% checkExistingFiles){ # If description in existing README include here
            fileIndex <- which(existingFileName == ifile)
            fileDescription <- sapply(splitExistingFiles, "[[", 3)[fileIndex]

            print(ifile)
            print("fileDescription")
            print(fileDescription)
            write(paste0("| ",ifile," | ", fileDescription), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name with existing description

          } else{
            write(paste0("| ",ifile," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name without description
          }
        }
      }


      ### Any extra sections
      if(length(titleLines > 3) & titleLines[which(titleLines ==fileTitle)+1] != folderTitle){
        write(existingREADME[titleLines[which(titleLines ==fileTitle)+1]:folderTitle-1], file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # If extra title not located here this just adds another empty line
      }


      ### Folder table
      # Add table header and description for folder table
      write(existingREADME[folderTitle:folderTabTop], file=paste(dirREADME,"README.md",sep="/"), append=TRUE)

      # Add divider for formatting
      write("| ----------- | ----------- |", file=paste(dirREADME,"README.md",sep="/"), append=TRUE)

      # Pull out existing table lines between:
      if(folderTitle == titleLines[length(titleLines)]){ # folderTabTop and end of file
        existingFolders <- existingREADME[(folderTabTop+1):length(existingREADME)]

        if("" %in% existingFolders){ # If no existing folders in README skip to fill in with new folders
          for(ifolder in folderNames){
            write(paste0("| ",ifolder," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write folder name without description

          }
        } else{ # Populate with new folders
          splitExistingFolders <- strsplit(existingFolders, "| ", fixed=TRUE)
          existingFolderNames <- sapply(splitExistingFolders,"[[",2) %>% strsplit(., " ", fixed=TRUE) # Remove space following folder name
          checkExistingFolders <- existingFolderNames[which(existingFolderNames %in% uniqueFile)]

          # Populate table
          for(ifolder in folderNames){
            if(ifolder %in% checkExistingFolders){ # If description in existing README include here
              folderIndex <- which(existingFolderNames == ifolder)
              folderDescription <- sapply(splitExistingFolders, "[[", 3)[folderIndex]

              write(paste0("| ",ifolder," | ", folderDescription), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name with existing description

            } else{
              write(paste0("| ",ifolder," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write folder name without description
            }
          } # End loop over folders
        }
      } else { # folderTabTop and any subsequent headers
        existingFolders <- existingREADME[(folderTabTop+1):length(existingREADME)]

        if("" %in% existingFolders){ # If no existing folders in README skip to fill in with new folders
          for(ifolder in folderNames){
            write(paste0("| ",ifolder," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write folder name without description

          }
        } else{ # Populate with new folders
          splitExistingFolders <- strsplit(existingFolders, "| ", fixed=TRUE)
          existingFolderNames <- sapply(splitExistingFolders,"[[",2) %>% strsplit(., " ", fixed=TRUE) # Remove space following folder name
          checkExistingFolders <- existingFolderNames[which(existingFolderNames %in% uniqueFile)]

          # Populate table
          for(ifolder in folderNames){
            if(ifolder %in% checkExistingFolders){ # If description in existing README include here
              folderIndex <- which(existingFolderNames == ifolder)
              folderDescription <- sapply(splitExistingFolders, "[[", 3)[folderIndex]

              write(paste0("| ",ifolder," | ", folderDescription), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name with existing description

            } else{
              write(paste0("| ",ifolder," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write folder name without description
            }
          } # End loop over folders

        } # End if statement about populating folders


        ### Any extra sections
        if(length(titleLines > 3) & is.na(titleLines[which(titleLines ==folderTitle)+1]) != TRUE){ # If the folderTitle is the last heading this won't be run
          write(" ", file=paste(dirREADME,"README.md",sep="/"), append=TRUE)
          write(existingREADME[titleLines[which(titleLines ==folderTitle)+1]:length(existingREADME)], file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # If extra title not located here this just adds another empty line
        }
      } # End if statement about end of file vs. end & subsequent headers




    } else{ # If folder table first autofill folder table first

      # If there are headers after the README title but before the folder table and file table fill them in here
      if(length(titleLines > 3) & titleLines[2] != fileTitle & titleLines[2] != folderTitle){
        write(existingREADME[titleLines[2]:folderTitle-1], file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # If extra title not located here this just adds another empty line
      }


      ### Folder table
      # Add table header and description for folder table
      write(existingREADME[folderTitle:folderTabTop], file=paste(dirREADME,"README.md",sep="/"), append=TRUE)

      # Add divider for formatting
      write("| ----------- | ----------- |", file=paste(dirREADME,"README.md",sep="/"), append=TRUE)

      # Pull out existing table lines between folderTabTop and following header
      existingFiles <- existingREADME[(folderTabTop+1):(titleLines[which(titleLines == folderTitle)+1]-2)]
      if("" %in% existingFolders){ # If no existing folders in README skip to fill in with new folders
        for(ifolder in folderNames){
          write(paste0("| ",ifolder," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write folder name without description
        }
      } else{ # Populate mix of old & new files
        splitExistingFolders <- strsplit(existingFolders, "| ", fixed=TRUE)
        existingFolderName <- sapply(splitExistingFolderss,"[[",2) %>% strsplit(., " ", fixed=TRUE) # Remove space following folder name
        checkExistingFolders <- existingFolderName[which(existingFolderName %in% uniqueFolder)]

        # Populate table
        for(ifolder in folderNames){
          if(ifolder %in% checkExistingFolders){ # If description in existing README include here
            folderIndex <- which(existingFolderName == ifolder)
            folderDescription <- sapply(splitExistingFolders, "[[", 3)[folderIndex]

            write(paste0("| ",ifolder," | ", folderDescription), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write folder name with existing description

          } else{
            write(paste0("| ",ifolder," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write folder name without description
          }
        }
      }


      ### Any extra sections
      if(length(titleLines > 3) & titleLines[which(titleLines ==folderTitle)+1] != fileTitle){
        write(existingREADME[titleLines[which(titleLines ==fileTitle)+1]:fileTitle-1], file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # If extra title not located here this just adds another empty line
      }


      ### File table
      # Add table header and description for file table
      write(existingREADME[fileTitle:fileTabTop], file=paste(dirREADME,"README.md",sep="/"), append=TRUE)

      # Add divider for formatting
      write("| ----------- | ----------- |", file=paste(dirREADME,"README.md",sep="/"), append=TRUE)

      # Pull out existing table lines between:
      if(fileTitle == titleLines[length(titleLines)]){ # fileTabTop and end of file
        existingFolders <- existingREADME[(fileTabTop+1):length(existingREADME)]

        if("" %in% existingFiles){ # If no existing files in README skip to fill in with new files
          for(ifile in fileNames){
            write(paste0("| ",ifile," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name without description

          }
        } else{ # Populate with new files
          splitExistingFiles <- strsplit(existingFiles, "| ", fixed=TRUE)
          existingFileNames <- sapply(splitExistingFiles,"[[",2) %>% strsplit(., " ", fixed=TRUE) # Remove space following file name
          checkExistingFiles <- existingFileNames[which(existingFileNames %in% uniqueFile)]

          # Populate table
          for(ifile in fileNames){
            if(ifile %in% checkExistingFiles){ # If description in existing README include here
              fileIndex <- which(existingFileNames == ifile)
              fileDescription <- sapply(splitExistingFiles, "[[", 3)[fileIndex]

              write(paste0("| ",ifile," | ", fileDescription), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name with existing description

            } else{
              write(paste0("| ",ifile," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name without description
            }
          } # End loop over filess
        }

      } else { # fileTabTop and any subsequent headers
        existingFiles <- existingREADME[(fileTabTop+1):length(existingREADME)]

        if("" %in% existingFiles){ # If no existing files in README skip to fill in with new files
          for(ifile in fileNames){
            write(paste0("| ",ifile," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name without description

          }
        } else{ # Populate with new files
          splitExistingFiles <- strsplit(existingFiles, "| ", fixed=TRUE)
          existingFileNames <- sapply(splitExistingFiles,"[[",2) %>% strsplit(., " ", fixed=TRUE) # Remove space following file name
          checkExistingFiles <- existingFileNames[which(existingFileNames %in% uniqueFile)]

          # Populate table
          for(ifile in fileNames){
            if(ifile %in% checkExistingFiles){ # If description in existing README include here
              fileIndex <- which(existingFileNames == ifile)
              fileDescription <- sapply(splitExistingFiles, "[[", 3)[fileIndex]

              write(paste0("| ",ifile," | ", fileDescription), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name with existing description

            } else{
              write(paste0("| ",ifile," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name without description
            }
          } # End loop over files

        } # End if statement about populating files


        ### Any extra sections
        if(length(titleLines > 3) & is.na(titleLines[which(titleLines ==fileTitle)+1]) != TRUE){ # If the fileTitle is the last heading this won't be run
          write(" ", file=paste(dirREADME,"README.md",sep="/"), append=TRUE)
          write(existingREADME[titleLines[which(titleLines ==fileTitle)+1]:length(existingREADME)], file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # If extra title not located here this just adds another empty line
        }
      } # End if statement about end of file vs. end & subsequent headers





  # End pull from existing README file
  } else{ # Generate new README

    # Fill in optional README title
    write(paste0("### ", title),file=paste(dirREADME,"README.md",sep="/"),append=FALSE)

    # Fill in optional description
    write(description,file=paste(dirREADME,"README.md",sep="/"),append=FALSE)

    # Populate table of files
    write(paste0("### ", "Files"), file = paste(dirREADME,"README.md",sep="/"), append = TRUE)
    write("| ----------- | ----------- |", file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Add divider for formatting
    for(ifile in fileNames){
        write(paste0("| ",ifile," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write file name without description
    }
    write(" ", file = paste(dirREADME,"README.md",sep="/"), append = TRUE) # Add empty line

    # Populate table of folders
    write(paste0("### ", "Folders"), file = paste(dirREADME,"README.md",sep="/"), append = TRUE)
    write("| ----------- | ----------- |", file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Add divider for formatting
    for(ifolder in folderNames){
      write(paste0("| ",ifolder," | ADD DESCRIPTION HERE |"), file=paste(dirREADME,"README.md",sep="/"), append=TRUE) # Write folder name without description
    }
  }

}

