from pylibdmtx.pylibdmtx import encode
from PIL import Image
import os

def generate_gs1_code(manufacturer, part_type, serial, lab_location):
    # Validate inputs
    if len(manufacturer) != 2 or not manufacturer.isalpha():
        raise ValueError("Manufacturer code must be exactly 2 letters.")
    if not part_type.isdigit():
        raise ValueError("Part type must be numeric.")
    if len(serial) != 3 or not serial.isdigit():
        raise ValueError("Serial number must be exactly 3 digits.")
    if len(lab_location) != 2 or not lab_location.isdigit():
        raise ValueError("Lab location code must be exactly 2 digits.")

    # Format GS1 Data (using Application Identifiers for standardization)
    # Example format: (01)Manufacturer-PartType-Serial-LabLocation
    gs1_code = f"(01){manufacturer}{part_type}{serial}{lab_location}"
    return gs1_code

def generate_datamatrix_image(gs1_code, output_path):
    encoded = encode(gs1_code.encode('utf-8'))
    img = Image.frombytes('RGB', (encoded.width, encoded.height), encoded.pixels)
    img.save(output_path, "JPEG")
    print(f"DataMatrix barcode saved as: {output_path}")

def main():
    print("GS1 DataMatrix Code Generator")

    # Input fields
    manufacturer = input("Enter 2-letter Manufacturer Code: ").upper()
    part_type = input("Enter Part Type (numeric): ")
    serial = input("Enter 3-digit Serial Number: ")
    lab_location = input("Enter 2-digit Lab Location Code: ")

    try:
        gs1_code = generate_gs1_code(manufacturer, part_type, serial, lab_location)
        # Determine the directory of the executable
        exe_dir = os.path.dirname(os.path.abspath(__file__))
        # Define the Tags folder path
        tags_dir = os.path.join(exe_dir, 'Tags')

        # Check if Tags folder exists or can be created
        if not os.path.exists(tags_dir):
            try:
                os.makedirs(tags_dir)
                output_dir = tags_dir
            except OSError:
                output_dir = exe_dir
        else:
            output_dir = tags_dir
        
        output_filename = f"GS1_{manufacturer}_{part_type}_{serial}_{lab_location}.jpg"
        output_path = os.path.join(output_dir, output_filename)
        generate_datamatrix_image(gs1_code, output_path)
    except ValueError as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
