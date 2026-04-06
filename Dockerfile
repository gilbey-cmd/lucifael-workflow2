# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.2 --mode remote
RUN comfy node install --exit-on-fail comfyui-impact-subpack@1.3.5
RUN comfy node install --exit-on-fail comfyui_essentials@1.1.0
RUN comfy node install --exit-on-fail rgthree-comfy@1.0.2512112053
# NOTE: There is an "unknown_registry" group in the workflow that contains nodes with no aux_id (no GitHub repo provided).
# Those could not be resolved automatically and are skipped. If you have a GitHub repo for them, add a RUN git clone line like:
# RUN git clone https://github.com/<owner>/<repo> /comfyui/custom_nodes/<repo>

# download models into comfyui
RUN comfy model download --url https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth --relative-path models/checkpoints --filename sam_vit_b_01ec64.pth
RUN comfy model download --url https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt --relative-path models/checkpoints --filename face_yolov8m.pt
# RUN # Could not find URL for bbox/Eyeful_v2-Paired.pt
# RUN # Could not find URL for mopMixtureOfPerverts_v20.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/