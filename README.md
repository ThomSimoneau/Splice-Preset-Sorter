# Splice-Preset-Sorter
A Powershell script that sorts presets based on a customizable Keywordmap into separate folders.

You can customize your keywords by changing the keyword map located in the script as such:

```
 $keywordMap = @{
        'ARP'   = 'ARP'
        'KEY'   = 'KEY'
        'SYNTH' = 'SYNTH'
        'BASS'  = 'BASS'
        'BS_'   = 'BASS'
        'BA_'   = 'BASS'
        'BA'    = 'BASS'
        'GROWL' = 'GROWL'
        'STAB'  = 'STAB'
        'FX'    = 'FX'
        'PLUCK' = 'PLUCK'
    }
```

The first column is the keyword used to sort the presets and the second column is the name of the folder in which your presets will end.

The folders are all located in a "Sorted" folder and all the files which were not able to be sorted by the keyword map in an "Unsorted" folder.

There seems to be some outliers that are not being sorted correctly but I'm tired and it does the job to the extent of my passion on the project.
You can submit a pull request and I'll gladly let you work on it. I'm not used to work on github with other contributors so let me know if there's something I haven't configured properly.
