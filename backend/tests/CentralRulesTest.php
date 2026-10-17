<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

/**
 * A rule exists once (catalog_rules) and every page that shows it must show exactly that text.
 */
final class CentralRulesTest extends AppTestCase
{
    public function testEveryPageShowsTheCentralTextOfAdvancementRules(): void
    {
        $id = (int) $this->json($this->request('POST', '/characters', $this->wizardPayload()), 200)['id'];
        $this->db->exec("UPDATE character_skills SET marked_for_advancement = 1 WHERE character_id = {$id} LIMIT 1");

        $rule = fn (string $code, string $column): string => (string) $this->db->query("SELECT {$column} FROM catalog_rules WHERE code = '{$code}'")
            ->fetchColumn();
        $page = fn (string $path): string => (string) $this->request('GET', $path)
            ->getBody();

        $marks = $rule('skill_marks', 'summary_de');
        self::assertStringContainsString($marks, $page('/character/' . $id));
        self::assertStringContainsString($rule('advancement_roll', 'summary_de'), $page('/character/' . $id . '/levelup'));

        $rules = $page('/rules');
        foreach (['skill_marks', 'session_end_questions', 'advancement_roll', 'dragon', 'demon', 'death_rolls'] as $code) {
            self::assertStringContainsString($rule($code, 'body_de'), $rules, $code);
        }

        $this->loginAsDm();
        self::assertStringContainsString($rule('session_end_questions', 'body_de'), $page('/dm/rules?k=spielleitung'));
    }

    public function testRuleTextMentionsMarksOnlyForDragonDemonAndTheSessionQuestions(): void
    {
        $summary = (string) $this->db->query("SELECT summary_de FROM catalog_rules WHERE code = 'skill_marks'")
            ->fetchColumn();

        self::assertStringContainsString('Drachen (1)', $summary);
        self::assertStringContainsString('Dämon (20)', $summary);
        self::assertStringContainsString('Sitzungsende', $summary);
    }
}
