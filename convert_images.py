import os
import subprocess

def convert_to_webp(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                input_path = os.path.join(root, file)
                output_path = os.path.splitext(input_path)[0] + '.webp'
                
                # Skip if webp already exists (unless we want to overwrite)
                # if os.path.exists(output_path):
                #     continue
                
                print(f"Converting {input_path} to {output_path}...")
                try:
                    subprocess.run(['ffmpeg', '-i', input_path, '-q:v', '75', output_path, '-y'], check=True, capture_output=True)
                except subprocess.CalledProcessError as e:
                    print(f"Error converting {input_path}: {e}")

if __name__ == "__main__":
    convert_to_webp('.')
