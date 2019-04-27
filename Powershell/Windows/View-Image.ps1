# https://gist.github.com/zippy1981/969855

param (
	[string] $filePath
)

[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")

$file = (Get-Item $filePath)
$img = [System.Drawing.Image]::Fromfile($file)

[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object Windows.Forms.Form
$form.Text = "Image Viewer"
$form.Width = $img.Size.Width
$form.Height =  $img.Size.Height

$pictureBox = New-Object Windows.Forms.PictureBox
$pictureBox.Width =  $img.Size.Width
$pictureBox.Height =  $img.Size.Height
$pictureBox.Image = $img

$form.Controls.Add($pictureBox)
$form.Add_Shown({ $form.Activate() })
$form.ShowDialog()
