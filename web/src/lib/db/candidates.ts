import { createServerSupabaseClient } from "@/lib/utils/supabase-server";
import type { Candidate, Result } from "@/types";

export async function getCandidatesByBatch(
  batchId: string
): Promise<Result<Candidate[]>> {
  const supabase = await createServerSupabaseClient();
  const { data, error } = await supabase
    .from("candidates")
    .select("*")
    .eq("batch_id", batchId)
    .order("name");

  if (error) return { success: false, error: error.message };
  return { success: true, data: data as Candidate[] };
}

export async function getCandidateById(
  id: string
): Promise<Result<Candidate>> {
  const supabase = await createServerSupabaseClient();
  const { data, error } = await supabase
    .from("candidates")
    .select("*")
    .eq("id", id)
    .single();

  if (error) return { success: false, error: error.message };
  return { success: true, data: data as Candidate };
}
