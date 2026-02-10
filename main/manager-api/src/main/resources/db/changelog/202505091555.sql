-- Update model provider table
UPDATE `ai_model_provider` SET fields = '[{"key": "host", "type": "string", "label": "Server Address"}, {"key": "port", "type": "number", "label": "Port Number"}, {"key": "type", "type": "string", "label": "Service Type"}, {"key": "is_ssl", "type": "boolean", "label": "Use SSL"}, {"key": "api_key", "type": "string", "label": "API Key"}, {"key": "output_dir", "type": "string", "label": "Output Directory"}]' WHERE id = 'SYSTEM_ASR_FunASRServer';

-- Update model configuration table
UPDATE `ai_model_config` SET
config_json = '{"host": "127.0.0.1", "port": 10096, "type": "fun_server", "is_ssl": true, "api_key": "none", "output_dir": "tmp/"}',
`doc_link` = 'https://github.com/modelscope/FunASR/blob/main/runtime/docs/SDK_advanced_guide_online_zh.md',
`remark` = 'Deploy FunASR independently and use its API service in just five steps:
Step 1: mkdir -p ./funasr-runtime-resources/models
Step 2: sudo docker run -p 10096:10095 -it --privileged=true -v $PWD/funasr-runtime-resources/models:/workspace/models registry.cn-hangzhou.aliyuncs.com/funasr_repo/funasr:funasr-runtime-sdk-online-cpu-0.1.12
After the previous command, you will enter the container. Continue with Step 3: cd FunASR/runtime
Do not exit the container. Continue executing Step 4 inside the container: nohup bash run_server_2pass.sh --download-model-dir /workspace/models --vad-dir damo/speech_fsmn_vad_zh-cn-16k-common-onnx --model-dir damo/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-onnx  --online-model-dir damo/speech_paraformer-large_asr_nat-zh-cn-16k-common-vocab8404-online-onnx  --punc-dir damo/punc_ct-transformer_zh-cn-common-vad_realtime-vocab272727-onnx --lm-dir damo/speech_ngram_lm_zh-cn-ai-wesp-fst --itn-dir thuduj12/fst_itn_zh --hotword /workspace/models/hotwords.txt > log.txt 2>&1 &
After the previous command executes, continue with Step 5: tail -f log.txt
After Step 5, you will see the model download logs. Once the download is complete, the service is ready to use.
The above uses CPU inference. If you have a GPU, refer to: https://github.com/modelscope/FunASR/blob/main/runtime/docs/SDK_advanced_guide_online_zh.md' WHERE `id` = 'ASR_FunASRServer';

-- FishSpeech configuration notes
UPDATE `ai_model_config` SET
`doc_link` = 'https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/docs/fish-speech-integration.md',
`remark` = 'FishSpeech Configuration Guide:
1. Requires local deployment of the FishSpeech service
2. Supports custom voice timbres
3. Local inference, no network connection required
4. Output files are saved in the tmp/ directory
5. Refer to the tutorial at https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/docs/fish-speech-integration.md' WHERE `id` = 'TTS_FishSpeech';
