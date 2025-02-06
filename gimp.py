from gimpfu import *

def create_default_image():
    # Create a new image with 1920x1080 dimensions
    img = gimp.Image(1920, 1080, RGB)
    layer = gimp.Layer(img, "Background", 1920, 1080, RGB_IMAGE, 100, NORMAL_MODE)
    img.add_layer(layer, 0)
    pdb.gimp.Display(img)

register(
    "create_default_image",
    "Create a 1920x1080 image",
    "Creates a new image with default size 1920x1080",
    "Your Name",
    "Your Name",
    "2025",
    "<Toolbox>/File/New 1920x1080",
    None,
    [],
    [],
    create_default_image
)

main()

