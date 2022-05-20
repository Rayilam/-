# project name
set project_name prj_0
	
# device and board
set device xczu19eg-ffvc1760-2-e
set board sugon:nf_card:part0:2.0

# setting up the project
create_project ${project_name} -force -dir "./${project_name}" -part ${device}
set_property board_part ${board} [current_project]

