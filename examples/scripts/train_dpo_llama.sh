set -x 

read -r -d '' training_commands <<EOF
../train_dpo.py \
     --save_path ./ckpt/7b_llama \
     --train_batch_size 128 \
     --micro_train_batch_size 1 \
     --pretrain meta-llama/Llama-2-7b-hf \
     --bf16 \
     --max_epochs 1 \
     --max_len 2048 \
     --zero_stage 3 \
     --beta 0.1 \
     --learning_rate 5e-7 \
     --dataset Anthropic/hh-rlhf,tasksource/oasst1_pairwise_rlhf_reward,lmsys/chatbot_arena_conversations,openai/webgpt_comparisons \
     --dataset_probs 0.72,0.08,0.12,0.08 \
     --flash_attn \
     --gradient_checkpointing \
     --load_model ./ckpt/7b_llama/sft_model_ocra.pt
EOF
     # --wandb [WANDB_TOKENS]


if [[ ${1} != "slurm" ]]; then
    export PATH=$HOME/.local/bin/:$PATH
    deepspeed $training_commands
fi
