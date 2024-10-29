import re
from datetime import datetime
from bokeh.plotting import figure, show
from bokeh.io import output_file

def parse_speed_data(file_path):
    timestamps = []
    speeds = []

    with open(file_path, 'r') as file:
        lines = file.readlines()
        for line in lines:
            timestamp_match = re.search(r'Timestamp: (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})', line)
            if timestamp_match:
                timestamps.append(datetime.strptime(timestamp_match.group(1), '%Y-%m-%d %H:%M:%S'))
       
            speed_match = re.search(r'\s+(\d+(\.\d+)?)\s+Mbits/sec', line)
            if speed_match and timestamps:
                speeds.append(float(speed_match.group(1)))

    return timestamps, speeds

file_path = 'sample_data/soal_chart_bokeh.txt'  
timestamps, speeds = parse_speed_data(file_path)

output_file("speed_chart.html")  
p = figure(title="Kecepatan Bandwidth Sender", x_axis_label='DATE TIME', y_axis_label='Speed (Mbps)', x_axis_type='datetime')
p.line(timestamps, speeds, legend_label="Speed (Mbps)", line_width=2, color='blue')
show(p)
