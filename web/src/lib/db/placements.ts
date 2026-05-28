import { createServerSupabaseClient } from "@/lib/utils/supabase-server";
import type { Placement, Result } from "@/types";

export async function getPlacementsByBatch(
  batchId: string
): Promise<Result<Placement[]>> {
  const supabase = await createServerSupabaseClient();
  const { data, error } = await supabase
    .from("placements")
    .select("*, candidates!inner(batch_id)")
    .eq("candidates.batch_id", batchId);

  if (error) return { success: false, error: error.message };
  return { success: true, data: data as Placement[] };
}

export async function updatePlacementStatus(
  id: string,
  status: Placement["status"]
): Promise<Result<Placement>> {
  const supabase = await createServerSupabaseClient();
  const { data, error } = await supabase
    .from("placements")
    .update({ status })
    .eq("id", id)
    .select()
    .single();

  if (error) return { success: false, error: error.message };
  return { success: true, data: data as Placement };
}
